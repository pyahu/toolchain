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
            { label: "Getting started", slug: "getting-started" },
            { label: "Choose profiles", slug: "profiles" },
            { label: "Common recipes", slug: "recipes" }
          ]
        },
        {
          label: "Help",
          items: [
            { label: "Troubleshooting", slug: "troubleshooting" },
            { label: "FAQ", slug: "faq" }
          ]
        },
        {
          label: "Reference",
          items: [
            { label: "Tool catalog", slug: "catalog" },
            { label: "Platform support", slug: "support" },
            { label: "Releases and upgrades", slug: "releases" },
            { label: "Update policy", slug: "updates" }
          ]
        },
        {
          label: "Project",
          items: [{ label: "Sharing kit", slug: "launch" }]
        }
      ]
    })
  ]
});
