vim.g.projectionist_heuristics = {
  ["build.gradle|pom.xml"] = {
    ["src/main/java/*.java"] = {
      type = "source",
      alternate = "src/test/java/{}Test.java",
    },
    ["src/test/java/*Test.java"] = {
      type = "test",
      alternate = "src/main/java/{}.java",
    },
  },
}
