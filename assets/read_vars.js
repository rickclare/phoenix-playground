import fs from "fs"
import chroma from "chroma-js"

const data = fs.readFileSync(process.argv[2], "utf8")

const jsonData = JSON.parse(data)
const collections = jsonData.collections

const core = collections.find((element) => element.name === "TalkType Core")

const coreColors = core.modes[0].variables
  .filter((el) => el.type === "color")
  .reduce((acc, color) => {
    acc[color.name] = color.value
    return acc
  }, {})

const coreColorCSS = Object.entries(coreColors)
  .map(([key, hex]) => {
    const parts = key.split("/")
    const val = chroma(hex).css("oklch")

    return `--${parts.join("-")}: ${val}; ${hex}`
  })
  .join("\n")

console.log(coreColorCSS)
