/* 变体切换：读地址里的 ?variant= 或 <html data-variant>，把预设应用到 data-* 属性。
   预设只是把四个属性打一次包，页面本身不需要改。 */

(function () {
  "use strict";

  var presets = {
    archive: { accent: "rust", density: "standard", motion: "full", theme: "dark" },
    nightrain: { accent: "verdigris", density: "standard", motion: "calm", theme: "dark" },
    salon: { accent: "gold", density: "roomy", motion: "full", theme: "dark" },
    dossier: { accent: "rust", density: "compact", motion: "calm", theme: "light" },
  };

  function apply(name) {
    var preset = presets[name];
    if (!preset) return;
    var root = document.documentElement;
    root.setAttribute("data-accent", preset.accent);
    root.setAttribute("data-density", preset.density);
    root.setAttribute("data-motion", preset.motion);
    if (preset.theme === "light") {
      root.setAttribute("data-theme", "light");
      root.setAttribute("data-surface", "paper");
    }
    root.setAttribute("data-variant", name);
  }

  function boot() {
    var fromUrl = null;
    try {
      fromUrl = new URLSearchParams(window.location.search).get("variant");
    } catch (e) {}
    var name = fromUrl || document.documentElement.getAttribute("data-variant");
    if (name) apply(name);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }

  window.r99 = window.r99 || {};
  window.r99.variant = apply;
})();
