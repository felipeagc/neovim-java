local home = vim.fn.expand("$HOME")
local bundles = { vim.fn.glob(home .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1) }
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/packages/java-test/extension/server/*.jar", 1), "\n"))

local config = {
    cmd = {
        home .. "/.local/share/nvim/mason/bin/jdtls",
        "--jvm-arg=" .. string.format(
            "-javaagent:%s",
            home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar"
        ),
    },
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    init_options = {
        bundles = bundles,
    },
}

require("jdtls").start_or_attach(config)
-- require("jdtls.dap").setup_dap_main_class_configs()

vim.keymap.set("n", "<leader>mi", function()
    require("jdtls").organize_imports()
end)

vim.keymap.set("n", "<leader>D", function()
    require("jdtls.dap").setup_dap_main_class_configs()
end)
vim.keymap.set("n", "<leader>tc", function()
    require("jdtls").test_class()
end)
vim.keymap.set("n", "<leader>tm", function()
    require("jdtls").test_nearest_method()
end)

vim.g.projectionist_heuristics = {
    ["pom.xml"] = {
      ["src/main/java/*.java"] = { alternate = "src/test/java/{}Test.java", type = "source" },
      ["src/test/java/*Test.java"] = { alternate = "src/main/java/{}.java", type = "test" },
    },
}