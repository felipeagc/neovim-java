local home = vim.fn.expand("$HOME")
local bundles = {}
local bundles = { vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1) }
vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar", 1), "\n"))

local launcher_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", 1)

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home.."/.jdtls-data/" .. project_name

local config = {
    cmd = {
        vim.fn.stdpath("data") .. "/mason/bin/jdtls",
        "-configuration",
        vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_linux",
        "--jvm-arg=" .. string.format(
            "-javaagent:%s",
            vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"
        ),
    },
    root_dir = vim.fs.dirname(vim.fs.find(
        {'gradlew', '.git', 'mvnw'},
        { upward = true }
    )[1]),
    init_options = { bundles = bundles },
}

require("jdtls").start_or_attach(config)

vim.keymap.set("n", "<leader>mi", require("jdtls").organize_imports)
vim.keymap.set("n", "<leader>D", require("jdtls.dap").setup_dap_main_class_configs)
vim.keymap.set("n", "<leader>tc", require("jdtls").test_class)
vim.keymap.set("n", "<leader>tm", require("jdtls").test_nearest_method)

vim.g.projectionist_heuristics = {
    ["pom.xml"] = {
        ["src/main/java/*.java"] = {
            alternate = "src/test/java/{}Test.java",
            type = "source",
        },
        ["src/test/java/*Test.java"] = {
            alternate = "src/main/java/{}.java",
            type = "test",
        },
    },
}
