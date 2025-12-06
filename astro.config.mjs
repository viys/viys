// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://viys.github.io',
  	base: '/viys',
	integrations: [
		starlight({
			title: 'My Docs',
			social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/viys' }],
			sidebar: [
				{
					label: 'Guides',
					items: [
						// Each item here is one entry in the navigation menu.
						{ label: '知识空间简介', slug: 'guides/introduction' },
					],
				},
				{
					label: 'K-Base',
					autogenerate: { directory: 'k_base' },
				},
				{
					label: 'Old',
					autogenerate: { directory: 'old' },
				},
			],
		}),
	],
});
