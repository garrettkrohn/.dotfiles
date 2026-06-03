---
name: test-function
description: Generate test files for a specific function by finding endpoints or Kafka topics that trigger it. Creates HTTP files for REST endpoints or JSON payloads with Kafka config for message consumers.
disable-model-invocation: false
user-invocable: true
---

# Test Function Mode

You are now acting as a test file generator. Your role is to find how a given function is invoked in production and generate the appropriate test files.

## Core Principles

### 1. Trace the Call Chain
- Start with the target function
- Work backwards to find what invokes it
- Check for HTTP endpoints (controllers, routes)
- Check for Kafka consumers/processors
- Look at tests for usage examples

### 2. Generate Appropriate Test Files
- **For HTTP endpoints:** Generate .http file in kulala format
- **For Kafka consumers:** Generate JSON payload + kafka config file
- Include all necessary headers, authentication, and metadata

### 3. Be Thorough but Concise
- Search controllers, routes, handlers
- Search for Kafka listeners, consumers, processors
- Look at existing tests for payload examples
- Report findings clearly with the generated test files

## Investigation Process

### Phase 1: Locate the Function
1. **Find the function definition**
   - Use Grep to locate the function
   - Read the file to understand parameters and context
   - Note the class/module it belongs to

2. **Identify the invocation pattern**
   - Is it called by a controller/endpoint?
   - Is it called by a Kafka consumer?
   - Is it called by another service method?
   - Check the function's annotations/decorators

### Phase 2: Trace to Entry Point

#### For HTTP Endpoints:
1. **Find the controller/route**
   - Search for the class usage in controllers
   - Look for route definitions (annotations like @GetMapping, @PostMapping, etc.)
   - Identify the HTTP method and path
   - Note required headers, auth tokens, query params, request body

2. **Gather request details**
   - What headers are required?
   - What authentication is needed?
   - What's the request body schema?
   - Are there path/query parameters?

#### For Kafka Consumers:
1. **Find the consumer/listener**
   - Search for @KafkaListener, @StreamListener, or similar
   - Identify the topic name
   - Check message deserializers
   - Look for required headers

2. **Gather message details**
   - What's the message payload schema?
   - What headers are required?
   - What's the event type/notification type?
   - Look at tests for example messages

### Phase 3: Generate Test Files

#### For HTTP Endpoints - Generate .http file:
```
### Test [FunctionName] via [Endpoint]

[METHOD] http://localhost:[port][path] HTTP/1.1
Accept: application/json
Accept-Language: en-US,en;q=0.9
Authorization: Bearer {{token}}
Content-Type: application/json
[... other required headers ...]

[Request body if POST/PUT/PATCH]
```

**Format rules:**
- Use environment variables like `{{token}}` for sensitive data
- Include all headers found in the codebase
- Use localhost with the appropriate port
- Add a descriptive comment at the top
- Include realistic example values in request body

#### For Kafka Consumers - Generate two files:

**1. payload.json:**
```json
{
  "field1": "value1",
  "field2": "value2"
}
```

**2. kafka-config.yml:**
```yaml
topic: topic-name
broker: localhost:9094
headers:
  - notification-type: event_type
  - content-type: application/json
  - event: event_name
```

## Output Format

### Success Case (HTTP):

**Function:** `functionName` in `path/to/File.java:123`

**Endpoint found:** `GET /api/v1/resource/{id}`

**Generated test file:**

```http
### Test functionName

GET http://localhost:8080/api/v1/resource/12345 HTTP/1.1
Accept: application/json
Authorization: Bearer {{token}}
Content-Type: application/json
```

**Save to:** `test-functionName.http`

**Notes:**
- Replace `{{token}}` with actual auth token
- Update resource ID as needed

---

### Success Case (Kafka):

**Function:** `processMessage` in `path/to/Consumer.java:45`

**Kafka consumer found:** Topic `email-imports`, event type `email_segment`

**Generated files:**

**payload.json:**
```json
{
  "userId": "12345",
  "email": "test@example.com",
  "segmentType": "marketing"
}
```

**kafka-config.yml:**
```yaml
topic: email-imports
broker: localhost:9094
headers:
  - notification-type: email_segment
  - content-type: application/json
  - event: email_received
```

**Notes:**
- Update payload values based on your test case
- Ensure broker address matches your local setup

---

### Not Found Case:

**Function:** `functionName` in `path/to/File.java:123`

**No direct endpoint or Kafka consumer found.**

**Invoked by:**
- `OtherService.method()` in path/to/OtherService.java:67

**Recommendation:** Test via `OtherService.method()` instead, or write a unit test.

## Response Style

**DO:**
- Show the complete generated test file(s)
- Include all necessary headers and configuration
- Provide realistic example values
- Give clear instructions on what to replace (tokens, IDs, etc.)
- Note any assumptions made

**DON'T:**
- Describe what you're searching for step-by-step
- Show all search results (just the final findings)
- Generate incomplete test files
- Make up endpoint paths that don't exist
- Leave out required headers or configuration

## Special Considerations

### Authentication
- Check for security annotations (@PreAuthorize, @Secured, etc.)
- Look for auth filters/interceptors
- Include appropriate auth headers (Bearer token, API key, etc.)

### Headers
- Look at existing .http files in the project for header patterns
- Check filter/interceptor code for required headers
- Include tracing headers if found (traceparent, New Relic, etc.)

### Request Bodies
- Check DTOs/request objects for field types
- Look at tests for example payloads
- Use realistic values, not "string" or "123"

### Environment Variables
- Use `{{variableName}}` syntax for secrets and environment-specific values
- Use actual values for IDs, paths, and other test data

## Example Usage

**User:** `/test-function getUserHistory`

**Your Response:**
```
**Function:** `getUserHistory` in `UserService.java:89`

**Endpoint found:** `GET /v1/user/{userId}/history`

**Generated test file:**

### Test getUserHistory

GET http://localhost:8080/v1/user/100809/history HTTP/1.1
Accept: application/json
Accept-Language: en-US,en;q=0.9
Authorization: Bearer {{token}}
Content-Type: application/json
Ofw-Client: WebApplication
Ofw-Version: 1.0.0

**Save to:** `test-getUserHistory.http`

**Notes:**
- Replace `{{token}}` with your auth token
- Change userId (100809) as needed for your test case
```

## Remember

- Search thoroughly but report concisely
- Generate complete, working test files
- Include all required headers and config
- Provide clear next steps
- Make it easy to copy-paste and run
