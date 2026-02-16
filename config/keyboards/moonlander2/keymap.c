#include QMK_KEYBOARD_H
#include "version.h"
#define MOON_LED_LEVEL LED_LEVEL
#ifndef ZSA_SAFE_RANGE
#define ZSA_SAFE_RANGE SAFE_RANGE
#endif

enum custom_keycodes {
  RGB_SLD = ZSA_SAFE_RANGE,
  HSV_0_245_245,
  HSV_74_255_206,
  HSV_152_255_255,
  ST_MACRO_0,
  ST_MACRO_1,
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    // base layer
  [0] = LAYOUT_moonlander(
    // main rows
    KC_Q,                   KC_W,                KC_E,                KC_R,                KC_T,                KC_NO,               KC_NO,                   KC_NO,               KC_NO,               KC_Y,                KC_U,                KC_I,                KC_O,                KC_P,
    MT(MOD_LCTL, KC_A),     MT(MOD_RALT, KC_S),  MT(MOD_LGUI, KC_D),  MT(MOD_LSFT, KC_F),  KC_G,                KC_NO,               KC_NO,                   KC_NO,               KC_NO,               KC_H,                MT(MOD_RSFT, KC_J),  MT(MOD_RGUI, KC_K),  MT(MOD_RALT, KC_L),  MT(MOD_RCTL, KC_SCLN),
    KC_Z,                   KC_X,                KC_C,                LT(3, KC_V),         KC_B,                KC_NO,               KC_NO,                   KC_NO,               KC_NO,               KC_N,                LT(4, KC_M),         KC_COMMA,            KC_DOT,              KC_SLASH,
    KC_NO,                  KC_NO,               KC_NO,               KC_NO,               KC_NO,               LT(2, KC_SPACE),                              LT(1, KC_BSPC),      KC_NO,               KC_NO,               KC_NO,               KC_NO,               KC_NO,
    // includes the red thumb keys                                                                              Red thumb key                                 Red thumb key
    KC_NO,                  KC_NO,               KC_NO,               KC_NO,               LT(2, KC_SPACE),     KC_NO,                                        KC_NO,               LT(1, KC_BSPC),      KC_NO,               KC_NO,               KC_NO,               KC_NO,
    KC_NO,                  KC_NO,               KC_NO,                                                                                                       KC_NO,               KC_NO,               KC_NO
  ),
    // symbols activated by right thumb
  [1] = LAYOUT_moonlander(
    KC_EXLM,        KC_AT,          KC_LCBR,        KC_RCBR,        KC_PLUS,        KC_NO,          KC_NO,                                          KC_NO,          KC_NO,          KC_NO,          KC_TILD,        KC_ASTR,        KC_CIRC,        KC_NO,
    KC_EQUAL,       KC_RABK,        KC_LPRN,        KC_RPRN,        KC_TAB,         KC_NO,          KC_NO,                                          KC_NO,          KC_NO,          KC_UNDS,        KC_QUOTE,       KC_DQUO,        KC_GRAVE,       KC_AMPR,
    KC_PERC,        KC_HASH,        KC_LBRC,        KC_RBRC,        KC_MINUS,       KC_NO,          KC_NO,                                          KC_NO,          KC_NO,          KC_NO,          KC_DLR,         KC_RIGHT_GUI,   KC_BSLS,        KC_PIPE,
    KC_NO,          KC_NO,          KC_NO,          KC_NO,          KC_NO,          KC_TRANSPARENT,                                                 KC_TRANSPARENT, KC_NO,          KC_NO,          KC_NO,          KC_NO,          KC_NO,
    KC_NO,          KC_NO,          KC_NO,          KC_NO,          KC_TRANSPARENT, KC_TRANSPARENT,                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_NO,          KC_NO,          KC_NO,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  ),
    //numbers activated by left thumb
  [2] = LAYOUT_moonlander(
    KC_NO,          KC_NO,          KC_NO,          KC_NO,          KC_NO,          KC_NO,          KC_NO,                                           KC_NO,          KC_NO,          KC_NO,          KC_7,           KC_8,           KC_9,           KC_NO,
    ST_MACRO_0,     ST_MACRO_1,     RGB_TOG,        LGUI(LSFT(KC_4)),KC_NO,          KC_NO,          KC_NO,                                          KC_NO,          KC_NO,          KC_MINUS,       KC_4,           KC_5,           KC_6,           KC_DOT,
    KC_F4,          KC_F3,          KC_F2,          KC_F1,          KC_NO,          KC_NO,          KC_NO,                                           KC_NO,          KC_NO,          KC_0,           KC_1,           KC_2,           KC_3,           KC_COLN,
    KC_NO,          KC_NO,          KC_NO,          KC_NO,          KC_NO,          KC_TRANSPARENT,                                                  KC_NO,          KC_NO,          KC_NO,          KC_NO,          KC_NO,          KC_NO,
    KC_NO,          KC_NO,          KC_NO,          KC_NO,          KC_TRANSPARENT, KC_TRANSPARENT,                                                  KC_TRANSPARENT, KC_TRANSPARENT,          KC_NO,          KC_NO,          KC_NO,          KC_NO,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                  KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  ),
    // navigation activated by V key
  [3] = LAYOUT_moonlander(
    KC_NO,        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_CAPS,        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_NO,        RGB_SPI,        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_LEFT,        KC_DOWN,        KC_UP,          KC_RIGHT,       KC_TRANSPARENT,
    KC_NO,        RGB_SPD,        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_F5,          KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_NO,        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_NO, KC_TRANSPARENT, HSV_0_245_245,  HSV_74_255_206, HSV_152_255_255,KC_TRANSPARENT,                                                        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_NO,                  KC_NO,               KC_NO,                                                                                           KC_NO,               KC_NO,               KC_NO
  ),
    // media, activated by the M key
  [4] = LAYOUT_moonlander(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_AUDIO_VOL_UP,KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_AUDIO_MUTE,  KC_MEDIA_PREV_TRACK,KC_MEDIA_PLAY_PAUSE,KC_MEDIA_NEXT_TRACK,KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_AUDIO_VOL_DOWN,KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  )
};

const uint16_t PROGMEM combo0[] = { MT(MOD_LGUI, KC_D), MT(MOD_LSFT, KC_F), COMBO_END}; // kc_quote
const uint16_t PROGMEM combo1[] = { MT(MOD_RSFT, KC_J),MT(MOD_RGUI, KC_K), COMBO_END}; // enter
const uint16_t PROGMEM combo2[] = { MT(MOD_RALT, KC_S), MT(MOD_LSFT, KC_F), COMBO_END}; // tab
const uint16_t PROGMEM combo3[] = { MT(MOD_RSFT, KC_J), MT(MOD_RALT, KC_L), COMBO_END}; // escape
const uint16_t PROGMEM combo4[] = { LT(4, KC_M), KC_COMMA, COMBO_END}; //minus
const uint16_t PROGMEM combo5[] = { KC_C, LT(3, KC_V), COMBO_END}; // underscore
const uint16_t PROGMEM combo6[] = { KC_E, KC_R, KC_U, KC_I, COMBO_END}; // bootloader mode

combo_t key_combos[COMBO_COUNT] = {
    COMBO(combo0, KC_QUOTE),
    COMBO(combo1, KC_ENTER),
    COMBO(combo2, KC_TAB),
    COMBO(combo3, KC_ESCAPE),
    COMBO(combo4, KC_MINUS),
    COMBO(combo5, KC_UNDS),
    COMBO(combo6, QK_BOOT),
};
