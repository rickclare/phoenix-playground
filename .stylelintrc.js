/* global module */

module.exports = {
  plugins: ["stylelint-prettier"],
  extends: ["stylelint-config-standard"],
  rules: {
    "prettier/prettier": true,
    "at-rule-no-unknown": [
      true,
      {
        ignoreAtRules: [
          "layer",
          "plugin",
          "screen",
          "source",
          "tailwind",
          "theme",
          "variant",
          "config",
        ],
      },
    ],
    "import-notation": "string",
    // See https://eslint.org/docs/latest/rules/no-warning-comments
    "comment-word-disallowed-list": [
      "BROKEN",
      "BUG",
      "ERROR",
      "FIXME",
      "HACK",
      "OPTIMIZE",
      "OPTIMISE",
      "REVIEW",
      "WTF",
      "XXX",
    ],
  },
}
