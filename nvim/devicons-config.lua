local colors = require('onedark.palette').cool
require('nvim-web-devicons').set_icon({
  scratchpad = {
    icon = '',
    color = '#6d8086',
    name = 'Scratchpad',
  },
  NeogitStatus = {
    icon = '',
    color = '#F14C28',
    name = 'BranchCycle',
  },
  org = {
    icon = '',
    color = '#75A899',
    name = 'Org',
  },
})
require('nvim-web-devicons').setup({
  override = {
    default_icon = {
      icon = '',
      name = 'Default',
    },
    -- css = {
    --   icon = '',
    --   color = colors.blue,
    --   name = 'css',
    -- },
    -- scss = {
    --   icon = '',
    --   color = colors.pink,
    --   name = 'scss',
    -- },
    -- sass = {
    --   icon = '',
    --   color = colors.mauve,
    --   name = 'sass',
    -- },
    js = {
      icon = '',
      color = colors.yellow,
      name = 'js',
    },
    ts = {
      icon = 'ﯤ',
      color = colors.blue,
      name = 'ts',
    },
    png = {
      icon = '',
      -- color = colors.mauve,
      name = 'png',
    },
    jpg = {
      icon = '',
      -- -- color = colors.sapphire,
      name = 'jpg',
    },
    jpeg = {
      icon = '',
      -- -- color = colors.sapphire,
      name = 'jpeg',
    },
    mp3 = {
      icon = '',
      -- color = colors.green,
      name = 'mp3',
    },
    mp4 = {
      icon = '',
      -- color = colors.green,
      name = 'mp4',
    },
    -- py = ,
    -- toml = ,
    -- lock = ,
    -- zip = ,
    -- xz = ,
    -- deb = ,
    -- rpm = ,
    -- lua = ,
    -- txt = ,
    -- md = ,
    -- ['docker-compose.yml'] = {
    --   icon = '',
    -- --   color = colors.sapphire,
    --   name = 'dockercompose',
    -- },
    -- ['.dockerignore'] = {
    --   icon = '',
    -- --   color = colors.peach,
    --   name = 'dockerignore',
    -- },
    ['.prettierignore'] = {
      icon = '',
      -- -- color = colors.peach,
      name = 'prettierignore',
    },
    ['.prettierrc'] = {
      icon = '',
      -- color = colors.sapphire,
      name = 'prettier',
    },
    ['.prettierrc.json'] = {
      icon = '',
      -- color = colors.sapphire,
      name = 'prettierjson',
    },
    ['.prettierrc.js'] = {
      icon = '',
      -- color = colors.sapphire,
      name = 'prettierrcjs',
    },
    ['prettier.config.js'] = {
      icon = '',
      -- color = colors.sapphire,
      name = 'prettierjsconfig',
    },
    ['.prettier.yaml'] = {
      icon = '',
      -- color = colors.sapphire,
      name = 'prettieryaml',
    },
    ['test.js'] = {
      icon = '',
      color = colors.yellow,
      name = 'javascripttest',
    },
    ['test.jsx'] = {
      icon = '',
      color = colors.yellow,
      name = 'reactrest',
    },
    ['test.ts'] = {
      icon = '',
      color = colors.blue,
      name = 'typescripttest',
    },
    ['test.tsx'] = {
      icon = '',
      color = colors.blue,
      name = 'reacttypescripttest',
    },
    ['spec.js'] = {
      icon = '',
      color = colors.yellow,
      name = 'javascriptspectest',
    },
    ['spec.jsx'] = {
      icon = '',
      color = colors.yellow,
      name = 'reactspectest',
    },
    ['spec.ts'] = {
      icon = '',
      color = colors.blue,
      name = 'typescriptspec',
    },
    ['spec.tsx'] = {
      icon = '',
      color = colors.blue,
      name = 'reacttypescriptspectest',
    },
    ['yarn-error.log'] = {
      icon = '',
      color = colors.red,
      name = 'yarnerrorlog',
    },
    ['yarn.lock'] = {
      icon = '',
      color = colors.blue,
      name = 'yarnlock',
    },
    ['.yarnrc'] = {
      icon = '',
      color = colors.blue,
      name = 'yarnconfig',
    },
    ['pnpm-lock.yaml'] = {
      icon = '',
      -- color = colors.peach,
      name = 'pnpmlock',
    },
    ['package.json'] = {
      icon = '',
      color = colors.green,
      name = 'npm_packagejson',
    },
    ['package-lock.json'] = {
      icon = '',
      color = colors.red,
      name = 'packagelockjson',
    },
    ['.gitignore'] = {
      icon = '',
      -- color = colors.maroon,
      name = 'gitignore',
    },
    ['.gitattributes'] = {
      icon = '',
      --   color = colors.peach,
      name = 'gitattributes',
    },
    ['Dockerfile'] = {
      icon = '',
      color = colors.blue,
      name = 'dockerfilex',
    },
    ['.nvmrc'] = {
      icon = '',
      color = colors.green,
      name = 'nvmrc',
    },
    ['.eslintrc.js'] = {
      icon = 'ﯶ',
      color = colors.mauve,
      name = 'eslintrcjs',
    },
    ['.travis.yml'] = {
      icon = '',
      color = colors.red,
      name = 'travis',
    },
    ['.babelrc'] = {
      icon = '',
      color = colors.yellow,
      name = 'babelrc',
    },
    ['babel.config.js'] = {
      icon = '',
      color = colors.yellow,
      name = 'babelconfig',
    },
    ['.commitlintrc.json'] = {
      icon = 'ﰚ',
      color = colors.green,
      name = 'commitlinrcjson',
    },
    ['commitlint.config.ts'] = {
      icon = 'ﰚ',
      color = colors.green,
      name = 'commitlintconfigts',
    },
    Makefile = {
      icon = '',
      color = colors.yellow,
      name = 'Makefile',
    },
    ['tsconfig.build.json'] = {
      icon = '',
      color = colors.blue,
      name = 'tsconfigbuildjson',
    },
    ['tsconfig.json'] = {
      icon = '',
      color = colors.blue,
      name = 'tsconfigjson',
    },
    ['nest-cli.json'] = {
      icon = '',
      color = colors.red,
      name = 'nestclijson',
    },
    ['vite.config.js'] = {
      icon = '',
      color = colors.yellow,
      name = 'viteconfigjs',
    },
    ['vite.config.ts'] = {
      icon = '',
      color = colors.blue,
      name = 'viteconfigts',
    },
    ['.editorconfig'] = {
      icon = '',
      -- color = colors.sky,
      name = 'editorconfig',
    },
    astro = {
      icon = '',
      --   color = colors.peach,
      name = 'astro',
    },
    zsh = {
      icon = '',
      --   color = colors.peach,
      name = 'zsh',
    },
    ['.zshrc'] = {
      icon = '',
      --   color = colors.peach,
      name = 'zshrc',
    },
    sh = {
      icon = '',
      color = colors.text,
      name = 'bash',
    },
    ['.bashrc'] = {
      icon = '',
      color = colors.text,
      name = 'bashrc',
    },
  },
  default = true,
})
