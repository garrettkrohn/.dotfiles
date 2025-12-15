#!/bin/bash

# Concurrent Curl Race Condition Tester
# Usage: ./race_test.sh <curl_file> <number_of_concurrent_requests> [output_dir]

set -e

# Check if curl file and number of requests are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <curl_file> <number_of_concurrent_requests> [output_dir]"
    echo "Example: $0 request.curl 10 ./results"
    exit 1
fi

CURL_FILE="$1"
NUM_REQUESTS="$2"
OUTPUT_DIR="${3:-./race_results}"

# Validate inputs
if [ ! -f "$CURL_FILE" ]; then
    echo "Error: Curl file '$CURL_FILE' not found!"
    exit 1
fi

if ! [[ "$NUM_REQUESTS" =~ ^[0-9]+$ ]] || [ "$NUM_REQUESTS" -lt 1 ]; then
    echo "Error: Number of requests must be a positive integer!"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "Starting race condition test..."
echo "Curl file: $CURL_FILE"
echo "Concurrent requests: $NUM_REQUESTS"
echo "Output directory: $OUTPUT_DIR"
echo "----------------------------------------"

# Function to run a single curl request
run_curl_request() {
    local request_id=$1
    local start_time=$(date +%s.%N)

    # Run the curl command from file and capture output
    curl -K "$CURL_FILE" \
        --write-out "REQUEST_ID: $request_id\nHTTP_CODE: %{http_code}\nTIME_TOTAL: %{time_total}\nTIME_CONNECT: %{time_connect}\nTIME_STARTTRANSFER: %{time_starttransfer}\n" \
        --output "$OUTPUT_DIR/response_$request_id.txt" \
        --stderr "$OUTPUT_DIR/error_$request_id.txt" \
        >"$OUTPUT_DIR/stats_$request_id.txt" 2>&1

    local end_time=$(date +%s.%N)
    local duration=$(echo "$end_time - $start_time" | bc -l)

    echo "WALL_TIME: $duration" >>"$OUTPUT_DIR/stats_$request_id.txt"
    echo "Request $request_id completed"
}

# Export the function so it can be used by background processes
export -f run_curl_request
export CURL_FILE OUTPUT_DIR

# Record start time
START_TIME=$(date +%s.%N)

echo "Launching $NUM_REQUESTS concurrent requests..."

# Launch all requests concurrently
for i in $(seq 1 "$NUM_REQUESTS"); do
    run_curl_request "$i" &
done

# Wait for all background processes to complete
wait

# Record end time
END_TIME=$(date +%s.%N)
TOTAL_TIME=$(echo "$END_TIME - $START_TIME" | bc -l)

echo "----------------------------------------"
echo "All requests completed!"
echo "Total execution time: ${TOTAL_TIME}s"

# Generate summary report
echo "Generating summary report..."
{
    echo "Race Condition Test Summary"
    echo "=========================="
    echo "Curl file: $CURL_FILE"
    echo "Number of requests: $NUM_REQUESTS"
    echo "Total execution time: ${TOTAL_TIME}s"
    echo "Start time: $(date -d @${START_TIME%.*} '+%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "Response Summary:"
    echo "----------------"

    # Count HTTP response codes
    if ls "$OUTPUT_DIR"/stats_*.txt >/dev/null 2>&1; then
        grep "HTTP_CODE:" "$OUTPUT_DIR"/stats_*.txt | cut -d: -f3 | sort | uniq -c | while read count code; do
            echo "HTTP $code: $count requests"
        done

        echo ""
        echo "Timing Analysis:"
        echo "---------------"

        # Calculate timing statistics
        echo "Request timings (seconds):"
        grep "TIME_TOTAL:" "$OUTPUT_DIR"/stats_*.txt | cut -d: -f3 | sort -n >"$OUTPUT_DIR/temp_times.txt"

        if [ -s "$OUTPUT_DIR/temp_times.txt" ]; then
            MIN_TIME=$(head -n1 "$OUTPUT_DIR/temp_times.txt")
            MAX_TIME=$(tail -n1 "$OUTPUT_DIR/temp_times.txt")
            AVG_TIME=$(awk '{sum+=$1} END {print sum/NR}' "$OUTPUT_DIR/temp_times.txt")

            echo "  Min: ${MIN_TIME}s"
            echo "  Max: ${MAX_TIME}s"
            echo "  Avg: ${AVG_TIME}s"
        fi

        rm -f "$OUTPUT_DIR/temp_times.txt"
    fi

    echo ""
    echo "Files generated:"
    echo "---------------"
    echo "- response_N.txt: HTTP response body for request N"
    echo "- stats_N.txt: Timing and HTTP status for request N"
    echo "- error_N.txt: Error output for request N"
    echo "- summary.txt: This summary report"

} >"$OUTPUT_DIR/summary.txt"

echo "Summary report saved to: $OUTPUT_DIR/summary.txt"
echo "Individual request files saved to: $OUTPUT_DIR/"

# Display quick summary
echo ""
echo "Quick Summary:"
if ls "$OUTPUT_DIR"/stats_*.txt >/dev/null 2>&1; then
    grep "HTTP_CODE:" "$OUTPUT_DIR"/stats_*.txt | cut -d: -f3 | sort | uniq -c | while read count code; do
        echo "  HTTP $code: $count requests"
    done
else
    echo "  No successful requests found"
fi
