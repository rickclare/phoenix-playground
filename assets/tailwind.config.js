const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

const brandReducer = (map, color) => {
  map[`brand-${color}`] = `oklch(from var(--theme-brand-${color}) l c h / <alpha-value>)`
  return map
}

module.exports = {
  content: ["./js/**/*.js", "../lib/playground_web.ex", "../lib/playground_web/**/*.*ex"],
  theme: {
    extend: {
      colors: ["primary", "secondary"].reduce(brandReducer, {}),
    },
  },
  plugins: [
    // require("@tailwindcss/forms"),

    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"]),
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"]),
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"]),
    ),

    plugin(function ({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"],
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      })
      matchComponents(
        {
          hero: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, "")
            let size = theme("spacing.6")
            if (name.endsWith("-mini")) {
              size = theme("spacing.5")
            } else if (name.endsWith("-micro")) {
              size = theme("spacing.4")
            }
            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              "-webkit-mask": `var(--hero-${name})`,
              mask: `var(--hero-${name})`,
              "mask-repeat": "no-repeat",
              "background-color": "currentColor",
              "vertical-align": "middle",
              display: "inline-block",
              width: size,
              height: size,
            }
          },
        },
        { values },
      )
    }),
  ],
}
