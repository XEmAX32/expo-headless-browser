enum HeadlessBrowserRuntime {
  static let script = """
    (function(){
      if (window.__expoWD) return;
      const WD = {
        uid: 0,
        reg: new WeakMap(),
        idMap: new Map(),
        toId(el) {
          if (!el) return null;
          let id = WD.reg.get(el);
          if (!id) {
            id = 'e' + (++WD.uid);
            WD.reg.set(el, id);
            WD.idMap.set(id, el);
            try { el.setAttribute('data-expo-eid', id); } catch(e){}
          }
          return id;
        },
        byId(id) {
          return WD.idMap.get(id) || document.querySelector('[data-expo-eid=\"' + id + '\"]') || null;
        }
      };
      window.__expoWD = WD;
    })();
    """
}