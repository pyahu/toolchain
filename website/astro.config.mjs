import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

export default defineConfig({
  site: "https://toolchain.terson.workers.dev",
  integrations: [
    starlight({
      title: "Pyahu Toolchain",
      description: "A curated mise setup for developer CLI tools.",
      logo: {
        src: "./src/assets/mark.svg",
        alt: "Pyahu Toolchain",
        replacesTitle: false
      },
      favicon: "/assets/mark.svg",
      customCss: ["./src/styles/starlight.css"],
      lastUpdated: true,
      social: [
        {
          icon: "github",
          label: "GitHub",
          href: "https://github.com/pyahu/toolchain"
        }
      ],
      sidebar: [
        {
          label: "Start here",
          items: [
            { label: "Overview", slug: "docs" },
            { label: "Getting started", slug: "docs/getting-started" },
            { label: "Choose profiles", slug: "docs/profiles" },
            { label: "Common recipes", slug: "docs/recipes" }
          ]
        },
        {
          label: "Help",
          items: [
            { label: "Troubleshooting", slug: "docs/troubleshooting" },
            { label: "FAQ", slug: "docs/faq" }
          ]
        },
        {
          label: "Reference",
          items: [
            { label: "Tool catalog", slug: "docs/catalog" },
            { label: "Platform support", slug: "docs/support" },
            { label: "Releases and upgrades", slug: "docs/releases" },
            { label: "Update policy", slug: "docs/updates" }
          ]
        },
        {
          label: "Project",
          items: [{ label: "Sharing kit", slug: "docs/launch" }]
        }
      ]
    })
  ]
});
