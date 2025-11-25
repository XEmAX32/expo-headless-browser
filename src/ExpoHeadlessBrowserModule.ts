import { NativeModule, requireNativeModule } from 'expo';

export type ExpoHeadlessBrowserModuleEvents = {};

declare class ExpoHeadlessBrowserModule extends NativeModule<ExpoHeadlessBrowserModuleEvents> {
  getTitleAsync(sessionId: string): Promise<string | null>;
  getCurrentUrlAsync(sessionId: string): Promise<string | null>;
  executeScriptAsync(sessionId: string, script: string): Promise<any>;
  getPageHtmlAsync(sessionId: string): Promise<string | null>;
  getElementByCssAsync(sessionId: string, selector: string): Promise<string | null>;
  getElementsByCssAsync(sessionId: string, selector: string): Promise<string[]>;
}


const _ExpoHeadlessBrowserModule = requireNativeModule<ExpoHeadlessBrowserModule>('ExpoHeadlessBrowser');

export default class Driver {
  public sessionId!: string;
  private ready: Promise<void>;

  constructor() {
    this.ready = _ExpoHeadlessBrowserModule.createSessionAsync().then((id: string) => { this.sessionId = id; });
    // _ExpoHeadlessBrowserModule.navigateAsync(this.sessionId, url);
  }

  private async ensureReady() { await this.ready; }

  async reload(): Promise<boolean> {
    await this.ensureReady();
    return _ExpoHeadlessBrowserModule.reloadAsync(this.sessionId);
  }

  async close(): Promise<boolean> {
    await this.ensureReady();
    return _ExpoHeadlessBrowserModule.closeSessionAsync(this.sessionId);
  }

  async get(url: string): Promise<boolean> {
    await this.ensureReady();
    return _ExpoHeadlessBrowserModule.navigateAsync(this.sessionId, url);
  }

  async dumptHtml(): Promise<string | null> {
    await this.ensureReady();
    return _ExpoHeadlessBrowserModule.getPageHtmlAsync(this.sessionId);
  }

  async executeScript<T = any>(script: string): Promise<T> {
    await this.ensureReady();
    return _ExpoHeadlessBrowserModule.executeScriptAsync(this.sessionId, script) as Promise<T>;
  }

  async getTitle(): Promise<string | null> {
    await this.ensureReady();
    return _ExpoHeadlessBrowserModule.getTitleAsync(this.sessionId);
  }
  
  async getCurrentUrl(): Promise<string | null> {
    await this.ensureReady();
    return _ExpoHeadlessBrowserModule.getCurrentUrlAsync(this.sessionId);
  }

  async getElementByClassName(className: string): Promise<any | null> {
    await this.ensureReady();
    const elementId = await _ExpoHeadlessBrowserModule.getElementByClassNameAsync(this.sessionId, className);
    return elementId ? new Element(this, elementId) : null;
  }

  async getElementsByClassName(className: string): Promise<any | null> {
    await this.ensureReady();
    const elementId = await _ExpoHeadlessBrowserModule.getElementsByClassNameAsync(this.sessionId, className);
    return elementId.map((id: string) => new Element(this, id));
  }

  async getElementById(id: string): Promise<any | null> {
    await this.ensureReady();
    const elementId = await _ExpoHeadlessBrowserModule.getElementByIdAsync(this.sessionId, id);
    return elementId ? new Element(this, elementId) : null;
  }

  async getElementByCss(selector: string): Promise<Element | null> {
    await this.ensureReady();
    const id = await _ExpoHeadlessBrowserModule.getElementByCssAsync(this.sessionId, selector);
    return id ? new Element(this, id) : null;
  }
  
  async getElementsByCss(selector: string): Promise<Element[]> {
    await this.ensureReady();
    const ids = await _ExpoHeadlessBrowserModule.getElementsByCssAsync(this.sessionId, selector);
    return ids.map(id => new Element(this, id));
  }

  async findElementByText(text: string): Promise<Element | null> {
    await this.ensureReady();
    const elementId = await _ExpoHeadlessBrowserModule.findElementByTextAsync(this.sessionId, text);
    return elementId ? new Element(this, elementId) : null;
  }

  async wait(milliseconds: number): Promise<boolean | null> {
    await this.ensureReady();
    return _ExpoHeadlessBrowserModule.wait(milliseconds);
  }

  async waitForElement(selector: string, timeout: number): Promise<boolean | null> {
    await this.ensureReady();
    return _ExpoHeadlessBrowserModule.waitForElement(this.sessionId, selector, timeout)
  }
  
}

class Element {
  constructor(
    protected driver: Driver,
    private id: string,
  ) {}

  async text(): Promise<string | null> {
    return _ExpoHeadlessBrowserModule.elementGetTextAsync(this.driver.sessionId, this.id);
  }

  async click(): Promise<boolean> {
    return _ExpoHeadlessBrowserModule.elementClickAsync(this.driver.sessionId, this.id);
  }

  async getAttribute(): Promise<string | null> {
    return _ExpoHeadlessBrowserModule.elementGetAttribute(this.driver.sessionId, this.id);
  }
}