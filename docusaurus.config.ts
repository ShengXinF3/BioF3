import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: 'BioF3 组学数据分析',
  tagline: '从基础到进阶的生物组学数据分析实践教程',
  favicon: 'img/biof3-favicon.png',

  // Future flags, see https://docusaurus.io/docs/api/docusaurus-config#future
  // future: {
  //   v4: true, // Improve compatibility with the upcoming Docusaurus v4
  // },

  // Set the production url of your site here.
  // Override these with SITE_URL and BASE_URL when deploying to a custom domain.
  url: process.env.SITE_URL ?? 'https://shengxinf3.github.io',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: process.env.BASE_URL ?? '/BioF3/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'ShengXinF3', // 你的 GitHub 用户名
  projectName: 'BioF3', // 你的项目名

  onBrokenLinks: 'throw',

  // 多语言配置：当前只维护简体中文内容
  i18n: {
    defaultLocale: 'zh-Hans',
    locales: ['zh-Hans'],
    localeConfigs: {
      'zh-Hans': {
        label: '简体中文',
        direction: 'ltr',
        htmlLang: 'zh-CN',
      },
    },
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          editUrl:
            'https://github.com/ShengXinF3/BioF3/tree/main/',  // 你的仓库
          showLastUpdateTime: false,
          showLastUpdateAuthor: false,
        },
        blog: {
          showReadingTime: true,
          blogTitle: 'BioF3 博客',
          blogDescription: '生物信息学数据分析经验分享',
          postsPerPage: 10,
          blogSidebarTitle: '最近文章',
          blogSidebarCount: 'ALL',
          feedOptions: {
            type: ['rss', 'atom'],
            title: 'BioF3 博客',
            description: '生物信息学数据分析经验分享',
          },
          editUrl:
            'https://github.com/ShengXinF3/BioF3/tree/main/',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  plugins: [
    [
      'plugin-image-zoom',
      {
        selector: '.markdown img',
        background: {
          light: 'rgba(255, 255, 255, 0.9)',
          dark: 'rgba(0, 0, 0, 0.9)'
        },
        config: {
          margin: 24,
          scrollOffset: 0,
        }
      }
    ],
  ],

  themeConfig: {
    // Replace with your project's social card
    image: 'img/docusaurus-social-card.jpg',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'BioF3',
      logo: {
        alt: 'BioF3 Logo',
        src: 'img/logo.jpg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: '教程',  // 修改为中文
        },
        {to: '/about', label: '关于', position: 'left'},
        {to: '/blog', label: '博客', position: 'left'},
        {href: 'https://biof3.com/blog-old/', label: '旧博客', position: 'left'},
        {
          href: 'https://github.com/ShengXinF3/BioF3',  // 你的 GitHub 仓库
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: '学习',
          items: [
            {
              label: '教程',
              to: '/docs/intro',
            },
            {
              label: '基础入门',
              to: '/docs/category/基础入门',
            },
          ],
        },
        {
          title: '社区',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/ShengXinF3/BioF3',
            },
            {
              label: 'Stack Overflow',
              href: 'https://stackoverflow.com/questions/tagged/bioinformatics',
            },
          ],
        },
        {
          title: '更多',
          items: [
            {
              label: '关于',
              to: '/about',
            },
            {
              label: '博客',
              to: '/blog',
            },
            {
              label: 'GitHub',
              href: 'https://github.com/ShengXinF3/BioF3',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} ShengXinF3. BioF3 组学数据分析实践教程.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
