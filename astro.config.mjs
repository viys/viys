// astro.config.mjs
import starlight from '@astrojs/starlight'
import { defineConfig } from 'astro/config'
import starlightThemeNova from 'starlight-theme-nova'

// https://astro.build/config
export default defineConfig({
  site: 'https://viys.github.io',
  base: '/viys',
  integrations: [
    starlight({
      plugins: [
        starlightThemeNova(/* options */), 
      ],
      title: 'My Blog',
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/viys' }
      ],
      sidebar: [
        {
          label: 'Guides',
          items: [{ label: '知识空间简介', slug: 'readme' }]
        },
        { label: 'K-Base', autogenerate: { directory: 'k_base' } },
        { label: 'Projectd', autogenerate: { directory: 'project' } }
      ],
    }),
  ],
});