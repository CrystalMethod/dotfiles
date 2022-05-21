vim.g.projectionist_heuristics = {
  ["build.gradle|pom.xml"] = {
    ["src/main/java/*.java"] = {
      type = "source",
      template = {
        "package {dirname|dot};",
        "",
        "public class {basename} {open}",
        "{close}",
      },
      alternate = "src/test/java/{}Test.java",
    },
    ["src/test/java/*Test.java"] = {
      type = "test",
      template = {
        "package {dirname|dot};",
        "",
        "public class {basename}Test {open}",
        "{close}",
      },
      alternate = "src/main/java/{}.java",
    },
  },
}
