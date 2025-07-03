return {
  -- Java LSP (Eclipse JDT Language Server)
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local jdtls = require("jdtls")
      
      -- Mason setup for jdtls (add this to ensure jdtls is installed)
      local mason_registry = require("mason-registry")
      if not mason_registry.is_installed("jdtls") then
        vim.cmd("MasonInstall jdtls")
      end

      -- Find workspace folder
      local workspace_folder = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = vim.fn.expand("~/.cache/jdtls-workspace/") .. workspace_folder

      -- Configuration
      local config = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4", 
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xms1g",
          "-Xmx2G",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-jar", vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
          "-configuration", vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_" .. (vim.fn.has("mac") == 1 and "mac" or "linux"),
          "-data", workspace_dir,
        },
        
        root_dir = jdtls.setup.find_root({".git", "mvnw", "gradlew", "pom.xml", "build.gradle"}),
        
        settings = {
          java = {
            eclipse = {
              downloadSources = true,
            },
            configuration = {
              updateBuildConfiguration = "interactive",
              runtimes = {
                -- Java runtimes here if needed
              },
            },
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            format = {
              enabled = true,
              settings = {
                url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
                profile = "GoogleStyle",
              },
            },
          },
          signatureHelp = { enabled = true },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
              "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
              "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
            },
            importOrder = {
              "java",
              "javax",
              "com",
              "org"
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
        },
        
        init_options = {
          bundles = {},
        },
        
        -- Use your existing LSP capabilities
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        
        -- Java-specific keybindings
        on_attach = function(client, bufnr)
          -- Your existing LSP keybindings will work
          -- Add Java-specific ones
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
          vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts)
          vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts)
          vim.keymap.set("v", "<leader>jm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
          vim.keymap.set("n", "<leader>jt", jdtls.test_class, opts)
          vim.keymap.set("n", "<leader>jn", jdtls.test_nearest_method, opts)
        end,
      }
      
      jdtls.start_or_attach(config)
    end,
  },

  -- Maven Integration
  {
    "eatgrass/maven.nvim",
    cmd = { "Maven", "MavenExec" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("maven").setup({
        executable = "./mvnw", -- Use Maven wrapper, fallback to "mvn"
        commands = {
          { cmd = { "clean" }, desc = "Clean project" },
          { cmd = { "compile" }, desc = "Compile project" },
          { cmd = { "test" }, desc = "Run tests" },
          { cmd = { "package" }, desc = "Package project" },
          { cmd = { "spring-boot:run" }, desc = "Run Spring Boot app" },
          { cmd = { "clean", "install" }, desc = "Clean and install" },
          { cmd = { "dependency:tree" }, desc = "Show dependency tree" },
        },
      })
      
      -- Maven keybindings
      vim.keymap.set("n", "<leader>mc", ":Maven compile<CR>", { desc = "Maven compile" })
      vim.keymap.set("n", "<leader>mt", ":Maven test<CR>", { desc = "Maven test" })
      vim.keymap.set("n", "<leader>mr", ":Maven spring-boot:run<CR>", { desc = "Maven run Spring Boot" })
      vim.keymap.set("n", "<leader>mp", ":Maven package<CR>", { desc = "Maven package" })
      vim.keymap.set("n", "<leader>mi", ":Maven clean install<CR>", { desc = "Maven clean install" })
      vim.keymap.set("n", "<leader>mm", ":Maven<CR>", { desc = "Maven menu" })
    end,
  },

  -- Java Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    ft = "java",
    config = function()
      local dap = require("dap")
      
      -- Java Debug Configuration
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1", 
          port = 5005,
        },
        {
          type = "java",
          request = "launch",
          name = "Debug (Launch) - Current File",
          mainClass = "${file}",
        },
        {
          type = "java",
          request = "launch", 
          name = "Debug Spring Boot",
          mainClass = "org.springframework.boot.loader.JarLauncher",
          args = "",
          vmArgs = "-Dspring.profiles.active=dev",
        },
      }
      
      -- Debug keybindings
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out" })
      
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()
    end,
  },

  -- Spring Boot utilities
  {
    "JavaHello/spring-boot.nvim",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls"
    },
    config = function()
      require("spring_boot").setup()
    end,
  },
}
