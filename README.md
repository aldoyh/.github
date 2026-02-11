# 👋 aldoyh

> A modern personal portfolio and profile page built with [Astro](https://astro.build), [Bulma](https://bulma.io), and [Alpine JS](https://github.com/alpinejs/alpine).

[![GitHub Profile](https://img.shields.io/badge/GitHub-aldoyh-blue?logo=github)](https://github.com/aldoyh)

## ✌️ Preview

This is the `.github` repository for aldoyh, featuring a custom landing page built with modern web technologies.

## 👍 Features

* Astro v4.x for fast static site generation
* Bulma 0.9.x for responsive UI components
* Alpine JS v3.x for interactive elements
* Automated deployments with GitHub Actions
* Docker support for containerized deployment
* Arabic fonts collection from Google Fonts (59 font families)

## 👌 Usage

### Development

1. Install Dependencies

```sh
pnpm install
```

2. Run in dev mode

```sh
pnpm dev
```

3. Build for production

```sh
pnpm build
```

4. Preview production build

```sh
pnpm preview
```

## 🚀 Deployment

The site is automatically deployed using GitHub Actions when changes are pushed to the main branch. The workflow:

1. Builds the Astro site
2. Creates a Docker image
3. Deploys to the hosting environment

## 🛠️ Workflows

This repository includes several GitHub Actions workflows:

- **deploy.yml** - Automated deployment pipeline
- **release.yml** - Release management and versioning
- **standard-version.yml** - Semantic versioning

## 🔤 Arabic Fonts

This repository includes a collection of 59 Arabic-supported fonts from [Google Fonts](https://github.com/google/fonts), located in the `arabic-fonts/` directory.

### Download Script

Use the included bash script to download Arabic fonts:

```sh
# Download all Arabic fonts
./download-arabic-fonts.sh

# Download a specific font by name
./download-arabic-fonts.sh --name "Amiri"
```

The script will:
1. Clone the Google Fonts repository
2. Scan all fonts for Arabic script support
3. Download matching fonts with their licenses and metadata
4. Generate a summary README with the list of downloaded fonts

See [arabic-fonts/README.md](arabic-fonts/README.md) for the complete list of available fonts.

## 📝 License

MIT License - See [LICENSE.md](LICENSE.md) for details.

## 🎨 Based on Krypton Template

This site is built on the [Krypton](https://github.com/cssninjaStudio/krypton) template by [cssninjaStudio](https://cssninja.io).
