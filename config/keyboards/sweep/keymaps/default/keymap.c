#include QMK_KEYBOARD_H

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  // base layer
  [0] = LAYOUT_split_3x5_2(
    KC_Q,               KC_W,               KC_E,               KC_R,            KC_T,              KC_Y,            KC_U,               KC_I,               KC_O,               KC_P,
    MT(MOD_LCTL, KC_A), MT(MOD_RALT, KC_S), MT(MOD_LGUI, KC_D), MT(MOD_LSFT, KC_F), KC_G,           KC_H,            MT(MOD_RSFT, KC_J), MT(MOD_RGUI, KC_K), MT(MOD_RALT, KC_L), MT(MOD_RCTL, KC_SCLN),
    KC_Z,               KC_X,               KC_C,               LT(3, KC_V),     KC_B,              KC_N,            LT(4, KC_M),        KC_COMMA,           KC_DOT,             KC_SLASH,
    KC_ESC,             LT(2, KC_SPC),                                                               LT(1, KC_BSPC), KC_ENT
  ),

  // symbols — activated by right thumb (LT1)
  [1] = LAYOUT_split_3x5_2(
    KC_EXLM,  KC_AT,   KC_LCBR, KC_RCBR, KC_PLUS,     KC_NO,   KC_TILD, KC_ASTR, KC_CIRC, KC_NO,
    KC_EQUAL, KC_RABK, KC_LPRN, KC_RPRN, KC_TAB,      KC_UNDS, KC_QUOT, KC_DQUO, KC_GRAVE,KC_AMPR,
    KC_PERC,  KC_HASH, KC_LBRC, KC_RBRC, KC_MINUS,    KC_NO,   KC_DLR,  KC_NO,   KC_BSLS, KC_PIPE,
    KC_TRNS,  KC_TRNS,                                          KC_TRNS, KC_TRNS
  ),

  // numbers — activated by left thumb (LT2)
  [2] = LAYOUT_split_3x5_2(
    KC_NO,   KC_NO,   KC_NO,   KC_NO,            KC_NO,     KC_NO,   KC_7, KC_8, KC_9, KC_NO,
    KC_TRNS, KC_TRNS, KC_NO,   LGUI(LSFT(KC_4)), KC_NO,     KC_MINS, KC_4, KC_5, KC_6, KC_DOT,
    KC_F4,   KC_F3,   KC_F2,   KC_F1,            KC_NO,     KC_0,    KC_1, KC_2, KC_3, KC_COLN,
    KC_TRNS, KC_TRNS,                                                 KC_TRNS, KC_TRNS
  ),

  // navigation — activated by V key (LT3)
  [3] = LAYOUT_split_3x5_2(
    KC_NO,   KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, KC_CAPS,            KC_TRNS,            KC_TRNS, KC_TRNS,
    KC_NO,   KC_NO,   KC_TRNS, KC_TRNS, KC_TRNS,    KC_LEFT, KC_DOWN,            KC_UP,              KC_RGHT, KC_TRNS,
    KC_NO,   KC_NO,   KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, TG(5),              LGUI(LSFT(KC_SPC)), LGUI(KC_I), KC_TRNS,
    KC_TRNS, KC_TRNS,                               KC_TRNS, KC_TRNS
  ),

  // mouseless — full qwerty, plain hjkl (no mod-tap), TG(5) exits
  [5] = LAYOUT_split_3x5_2(
    KC_Q, KC_W, KC_E, KC_R, KC_T,    KC_Y, KC_U,    KC_I,    KC_O,   KC_P,
    KC_A, KC_S, KC_D, KC_F, KC_G,    KC_H, KC_J,    KC_K,    KC_L,   KC_SCLN,
    KC_Z, KC_X, KC_C, KC_V, KC_B,    KC_N, KC_M,    KC_COMM, KC_DOT, KC_SLSH,
    KC_NO, KC_SPC,                          TG(5),   KC_NO
  ),

  // media — activated by M key (LT4)
  [4] = LAYOUT_split_3x5_2(
    KC_TRNS,       KC_TRNS,         KC_TRNS,            KC_AUDIO_VOL_UP,   KC_TRNS,    KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
    KC_AUDIO_MUTE, KC_MEDIA_PREV_TRACK, KC_MEDIA_PLAY_PAUSE, KC_MEDIA_NEXT_TRACK, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
    KC_TRNS,       KC_TRNS,         KC_TRNS,            KC_AUDIO_VOL_DOWN, KC_TRNS,    KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
    KC_TRNS,       KC_TRNS,                                                            KC_TRNS, KC_TRNS
  ),
};

const uint16_t PROGMEM combo0[] = { MT(MOD_LGUI, KC_D), MT(MOD_LSFT, KC_F), COMBO_END };  // D+F = '
const uint16_t PROGMEM combo1[] = { MT(MOD_RSFT, KC_J), MT(MOD_RGUI, KC_K), COMBO_END };  // J+K = enter
const uint16_t PROGMEM combo2[] = { MT(MOD_RALT, KC_S), MT(MOD_LSFT, KC_F), COMBO_END };  // S+F = tab
const uint16_t PROGMEM combo3[] = { MT(MOD_RSFT, KC_J), MT(MOD_RALT, KC_L), COMBO_END };  // J+L = escape
const uint16_t PROGMEM combo4[] = { LT(4, KC_M), KC_COMMA, COMBO_END };                    // M+, = -
const uint16_t PROGMEM combo5[] = { KC_C, LT(3, KC_V), COMBO_END };                        // C+V = _
const uint16_t PROGMEM combo6[] = { KC_E, KC_R, KC_U, KC_I, COMBO_END };                   // E+R+U+I = bootloader

combo_t key_combos[] = {
    COMBO(combo0, KC_QUOTE),
    COMBO(combo1, KC_ENTER),
    COMBO(combo2, KC_TAB),
    COMBO(combo3, KC_ESCAPE),
    COMBO(combo4, KC_MINUS),
    COMBO(combo5, KC_UNDS),
    COMBO(combo6, QK_BOOT),
};

layer_state_t layer_state_set_user(layer_state_t state) {
    static bool ml_active = false;
    bool on = IS_LAYER_ON_STATE(state, 5);

    if (on && !ml_active) {
        tap_code16(LGUI(KC_SPC));
        ml_active = true;
    } else if (!on && ml_active) {
        tap_code(KC_ESC);
        ml_active = false;
    }
    return state;
}
