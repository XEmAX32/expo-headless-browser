<p align="center">
  <sub>Beta • Headless Safari automation for Expo + React Native</sub>
</p>

<h1 align="center">Expo Headless Browser</h1>
<p align="center">Drive a zero-UI WKWebView session from JavaScript to crawl, scrape, and test the web directly inside your Expo app.</p>

<p align="center">
  <a href="https://www.npmjs.com/package/expo-headless-browser"><img src="https://img.shields.io/npm/v/expo-headless-browser.svg?style=flat-square&color=black" alt="npm version"></a>
  <a href="https://github.com/XEmAX32/expo-headless-browser/actions"><img src="https://img.shields.io/badge/ios-supported-blue?style=flat-square" alt="platform"></a>
  <a href="https://www.npmjs.com/package/expo-headless-browser"><img src="https://img.shields.io/npm/dm/expo-headless-browser?style=flat-square&color=orange" alt="npm downloads"></a>
  <a href="https://github.com/XEmAX32/expo-headless-browser/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="license"></a>
</p>

---

## Table of contents

1. [What is Expo Headless Browser?](#what-is-expo-headless-browser)
2. [Key features](#key-features)
3. [When should you use it?](#when-should-you-use-it)
4. [Getting started](#getting-started)
5. [Quickstart](#quickstart)
6. [API highlights](#api-highlights)
7. [Example flows](#example-flows)
8. [Architecture at a glance](#architecture-at-a-glance)
9. [Roadmap](#roadmap)
10. [Contributing](#contributing)
11. [Community & support](#community--support)
12. [License](#license)

---

## What is Expo Headless Browser?

`expo-headless-browser` is an Expo Module that embeds an off-screen `WKWebView` and exposes a high-level JavaScript driver you can use to script fully fledged browsing sessions. It is designed for **mobile-native data collection, scraping, QA automation, and content preview** workflows that need to run from an Expo app, background service, or custom dev tool.

The package is published on npm: [expo-headless-browser](https://www.npmjs.com/package/expo-headless-browser).

> ⚠️ **Status:** iOS is implemented. Android support and production hardening are being tracked in the roadmap below. Expect breaking changes until `1.0`.

## Key features

- **Headless sessions** – spin up isolated, non-persistent browser contexts per task without showing UI.
- **DOM automation** – query DOM nodes via CSS selectors, IDs, class names, or free-text search, then click, read text, or inspect attributes.
- **Script injection** – run arbitrary JavaScript inside the page context to interact with frameworks or expose custom helpers.
- **HTML extraction** – dump the entire HTML, capture titles, and read the current URL for audit trails.
- **Expo-first developer experience** – ship as a standard Expo module with TypeScript types, tree-shakeable bundling, and an included example app.

## When should you use it?

- Build on-device scrapers or research tools where sending credentials to a server-side bot is not an option.
- Run integration tests against live sites from an Expo dev client.
- Prototype background tasks that need to fetch dynamic content rendered by JavaScript.
- Capture metadata (OG tags, structured data, etc.) before opening a link in a normal browser view.

If you only need static HTTP fetches or HTML parsing, use `fetch` + `cheerio`. Reach for Expo Headless Browser when you must execute client-side JavaScript or interact with the DOM.

Inspired by [Selenium](https://github.com/SeleniumHQ/selenium).

## Getting started

### Requirements

- Expo SDK 54+ / React Native 0.81+
- Xcode 15+ (for iOS builds)
- Node.js 18+

### Installation

```sh
npm install expo-headless-browser
# or
yarn add expo-headless-browser
```

For bare Expo / React Native projects, make sure you have [installed and configured Expo modules](https://docs.expo.dev/bare/installing-expo-modules/) and then run:

```sh
npx pod-install
```

Managed Expo apps can use the module via config plugins once the package lands in an Expo SDK release. Until then you can run it inside the Expo Dev Client / Development Build.

## Quickstart

```ts
import HeadlessBrowser from 'expo-headless-browser';

async function scrapeHeadline() {
  const browser = new HeadlessBrowser();

  await browser.get('https://news.ycombinator.com');
  await browser.wait(500); // allow client-side scripts to hydrate

  const title = await browser.getTitle();
  const firstStory = await browser.getElementByCss('.athing .titleline a');

  console.log('Page title:', title);
  console.log('Top story:', await firstStory?.text());

  await browser.close();
}
```

👉 Run `cd example && npm install && npx expo start` to try a pre-wired playground.

## API highlights

| API | Description |
| --- | --- |
| `new HeadlessBrowser()` | Creates a new isolated session and boots an off-screen `WKWebView`. |
| `browser.get(url)` | Navigate to a URL and wait for the load event. |
| `browser.reload()` / `browser.close()` | Refresh or dispose the session. |
| `browser.executeScript(script)` | Evaluate arbitrary JavaScript and return the serialized value. |
| `browser.dumptHtml()` | Capture the page HTML snapshot. |
| `browser.getElementByCss(selector)` / `getElementsByCss` | Query one or multiple DOM nodes via CSS selectors. |
| `browser.getElementById(id)` / `getElementByClassName(class)` | Convenience selectors. |
| `browser.findElementByText(text)` | Walk the DOM tree to find the first element that contains the given text. |
| `element.text()` / `element.click()` / `element.getAttribute(name)` | Interact with element handles returned by the selectors above. |

All APIs return promises. Call `await browser.wait(ms)` to pause between actions when the target website needs extra hydration time.

## Example flows

### Fill out a form

```ts
const form = await browser.getElementByCss('form#credentials');
if (!form) throw new Error('Form not found');

const emailInput = await browser.executeScript<string>(`
  (function () {
    const el = document.querySelector('form#credentials input[type=email]');
    el.value = 'user@example.com';
    return el.value;
  })();
`);

const submit = await browser.getElementByCss('form#credentials button[type=submit]');
await submit?.click();
await browser.wait(1500);
```

### Collect product cards

```ts
const cards = await browser.getElementsByCss('.product-card');
const results = await Promise.all(
  cards.map(async card => ({
    name: await card.text(),
    href: await card.getAttribute('href'),
  }))
);
```

These snippets can run inside your Expo app, a background task, or even a CLI powered by `expo run:ios --device`.

## Architecture at a glance

1. **JavaScript driver** (`src/ExpoHeadlessBrowserModule.ts`) exposes a typed `Driver` class that wraps the native module APIs.
2. **Native module** manages WebKit sessions, injects a lightweight runtime to map DOM nodes to opaque IDs, and forwards method calls such as `navigate`, `executeScript`, and `elementClick`.
3. **Session manager** keeps every `WKWebView` isolated with non-persistent storage so cookies/cache never leak between runs.
4. **Bridge** uses Expo Modules Core, so there is no custom native setup—install, run `pod install`, and start automating.

Because everything rides on standard Expo infrastructure, you can leverage OTA updates, TypeScript, and metro bundling just like any other module.

## Roadmap

- [ ] Android implementation powered by `WebView` + `WebViewAssetLoader`.
- [ ] Screenshot and PDF capture helpers.
- [ ] Built-in waits (`waitForElement`, `waitForNavigation`) exposed to JS.
- [ ] Configurable user agents and HTTP headers per session.

Track progress or propose new ideas via [GitHub Issues](https://github.com/XEmAX32/expo-headless-browser/issues).

## Contributing

Contributions are very welcome! Open an issue describing the feature/bug first, then:

1. Fork the repo and install dependencies.
2. Work inside the `src/` folder and run `npm run build` to sync TypeScript to `build/`.
3. Use the `example/` app to test end-to-end (`npx expo start`).
4. Submit a PR with screenshots/logs that prove the change works.

Please follow the [Expo contribution guidelines](https://github.com/expo/expo#contributing) for code style and commit hygiene.

## Community & support

- **Questions / ideas:** open a [GitHub Discussion](https://github.com/XEmAX32/expo-headless-browser/discussions) or file an issue.
- **Bugs:** provide a minimal repro inside the `example/` app so we can debug quickly.
- **Releases:** watch the npm package or star the repo to get notified about beta drops.

## License

MIT © [Emanuele Sacco](https://github.com/XEmAX32). Use it commercially, ship it in your apps, and drop a star if it helps you build something cool.
