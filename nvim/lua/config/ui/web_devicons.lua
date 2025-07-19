return {
  'nvim-tree/nvim-web-devicons',
  lazy = true,
  config = function()
    require('nvim-web-devicons').set_icon({
      -- astro = {
      --   icon = '',
      --   color = '#e23f67',
      --   cterm_color = '197',
      --   name = 'Astro',
      -- },
      dart = {
        icon = '',
        color = '#51a0cf',
        cterm_color = '25',
        name = 'Dart',
      },
      Dockerfile = {
        icon = '',
        color = '#458ee6',
        cterm_color = '68',
        name = 'Dockerfile',
      },
      js = {
        icon = '󰌞',
        color = '#F1F134',
        cterm_color = '185',
        name = 'Js',
      },
      json = {
        icon = '󰘦',
        color = '#F1F134',
        cterm_color = '185',
        name = 'Json',
      },
      json5 = {
        icon = '󰘦',
        color = '#F1F134',
        cterm_color = '185',
        name = 'Json5',
      },
      jsonc = {
        icon = '󰘦',
        color = '#F1F134',
        cterm_color = '185',
        name = 'Jsonc',
      },
      lock = {
        icon = '󰌾',
        color = '#bbbbbb',
        cterm_color = '250',
        name = 'Lock',
      },
      mp3 = {
        icon = '󰎆',
        color = '#E8274B',
        cterm_color = '45',
        name = 'Mp3',
      },
      -- mp4 = {
      --   icon = '',
      --   name = 'mp4',
      -- },
      out = {
        icon = '',
        name = 'out',
      },
      ['robots.txt'] = {
        icon = '󰚩',
        color = '#6d8086',
        cterm_color = '66',
        name = 'Robots',
      },
      toml = {
        icon = '',
        color = '#51a0cf',
        cterm_color = '74',
        name = 'Toml',
      },
      ts = {
        icon = '󰛦',
        color = '#519aba',
        cterm_color = '74',
        name = 'TypeScript',
      },
      xz = {
        icon = '',
        color = '#6d8086',
        cterm_color = '66',
        name = 'Xz',
      },
      zip = {
        icon = '',
        color = '#6d8086',
        cterm_color = '66',
        name = 'Zip',
      },
      zsh = {
        icon = '',
        color = '#e37933',
        cterm_color = '172',
        name = 'Zsh',
      },
      bash = {
        icon = '',
        color = '#e37933',
        cterm_color = '172',
        name = 'Bash',
      },
      sh = {
        icon = '',
        color = '#e37933',
        cterm_color = '172',
        name = 'Sh',
      },
      ['.bashrc'] = {
        icon = '',
        color = '#e37933',
        cterm_color = '172',
        name = 'Bash',
      },

      -- Config files
      ['yarn-error.log'] = {
        icon = '',
        color = '#458ee6',
        cterm_color = '68',
        name = 'Yarnerrorlog',
      },
      ['yarn.lock'] = {
        icon = '',
        color = '#458ee6',
        cterm_color = '68',
        name = 'Yarnlock',
      },
      ['.yarnrc'] = {
        icon = '',
        color = '#458ee6',
        cterm_color = '68',
        name = 'Yarnconfig',
      },
      ['pnpm-lock.yaml'] = {
        icon = '󰀻',
        color = '#FFB300',
        cterm_color = '208',
        name = 'Pnpmlock',
      },
      -- ['package.json'] = {
      --   icon = '',
      --   color = '#019833',
      --   cterm_color = '28',
      --   name = 'Npm_packagejson',
      -- },
      -- ['package-lock.json'] = {
      --   icon = '',
      --   color = '#019833',
      --   cterm_color = '28',
      --   name = 'Npm_packagejson',
      -- },
      -- ['.nvmrc'] = {
      --   icon = '',
      --   color = '#019833',
      --   cterm_color = '28',
      --   name = 'Npm_packagejson',
      -- },
      ['babel.config.js'] = {
        icon = '',
        color = '#cbcb41',
        cterm_color = '185',
        name = 'Babelrc',
      },
      ['vite.config.js'] = {
        icon = '', -- '',
        color = '#FD971F',
        cterm_color = '208',
        name = 'ViteConfigFile',
      },
      ['vite.config.ts'] = {
        icon = '',
        color = '#FD971F',
        cterm_color = '208',
        name = 'ViteConfigFile',
      },
      ['.gitattributes'] = {
        icon = '',
        color = '#f54d27',
        cterm_color = '196',
        name = 'GitAttributes',
      },
      ['.gitconfig'] = {
        icon = '',
        color = '#f54d27',
        cterm_color = '196',
        name = 'GitConfig',
      },

      -- Media
      avif = {
        icon = '󰈟',
        color = '#89e051',
        cterm_color = '113',
        name = 'Avif',
      },
      bmp = {
        icon = '󰈟',
        color = '#89e051',
        cterm_color = '113',
        name = 'Bmp',
      },
      gif = {
        icon = '󰈟',
        color = '#89e051',
        cterm_color = '113',
        name = 'Gif',
      },
      ico = {
        icon = '󰈟',
        color = '#cbcb41',
        cterm_color = '185',
        name = 'Ico',
      },
      jpeg = {
        icon = '󰈟',
        color = '#89e051',
        cterm_color = '113',
        name = 'Jpeg',
      },
      jpg = {
        icon = '󰈟',
        color = '#89e051',
        cterm_color = '113',
        name = 'Jpg',
      },
      jxl = {
        icon = '󰈟',
        color = '#89e051',
        cterm_color = '113',
        name = 'JpegXl',
      },
      png = {
        icon = '󰈟',
        color = '#89e051',
        cterm_color = '113',
        name = 'Jpg',
      },
      webp = {
        icon = '󰈟',
        color = '#89e051',
        cterm_color = '113',
        name = 'Webp',
      },

      -- Custom filetypes
      NeogitStatus = {
        icon = '',
        color = '#f54d27',
        name = 'GitBranchStatus',
      },
      DiffviewFiles = {
        icon = '',
        color = '#f54d27',
        name = 'GitBranchStatus',
      },
    })
  end,
}
