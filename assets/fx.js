/* reverse1999-ui 网页交互
   只做四件事：主题记忆、滚动入场、页签切换、浮层与提示。
   不依赖框架，重复调用不会重复绑定。 */

(function () {
  "use strict";

  var root = document.documentElement;
  var THEME_KEY = "r99-theme";

  function theme(name) {
    root.setAttribute("data-theme", name);
    try {
      localStorage.setItem(THEME_KEY, name);
    } catch (e) {}
    document.querySelectorAll("[data-r99-theme-toggle]").forEach(function (btn) {
      btn.setAttribute("aria-pressed", String(name === "light"));
    });
  }

  function restoreTheme() {
    var saved = null;
    try {
      saved = localStorage.getItem(THEME_KEY);
    } catch (e) {}
    if (saved === "light" || saved === "dark") {
      theme(saved);
    } else if (window.matchMedia("(prefers-color-scheme: light)").matches) {
      theme("light");
    }
  }

  function wireTheme() {
    document.querySelectorAll("[data-r99-theme-toggle]").forEach(function (btn) {
      if (btn.dataset.r99Wired) return;
      btn.dataset.r99Wired = "1";
      btn.addEventListener("click", function () {
        theme(root.getAttribute("data-theme") === "light" ? "dark" : "light");
      });
    });
  }

  function reveal() {
    var explicit = document.querySelectorAll("[data-r99-reveal]");
    var items = explicit.length
      ? explicit
      : document.querySelectorAll(
          ".r99-plate, .r99-panel, .r99-card, .r99-list > li, .r99-figure, .r99-table, .r99-stat, .r99-empty"
        );
    if (!items.length) return;
    Array.prototype.forEach.call(items, function (el, i) {
      if (el.classList.contains("r99-in")) return;
      if (el.hasAttribute("data-r99-skip")) return;
      el.style.setProperty("--d", (i % 6) * 60 + "ms");
      el.classList.add("r99-reveal");
    });
    if (!("IntersectionObserver" in window)) {
      items.forEach(function (el) {
        el.classList.add("r99-in");
      });
      return;
    }
    var io = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (!entry.isIntersecting) return;
          entry.target.classList.remove("r99-reveal");
          entry.target.classList.add("r99-in");
          io.unobserve(entry.target);
        });
      },
      { rootMargin: "0px 0px -8% 0px", threshold: 0.08 }
    );
    items.forEach(function (el) {
      io.observe(el);
    });
  }

  function wireTabs() {
    document.querySelectorAll("[data-r99-tabs]").forEach(function (group) {
      if (group.dataset.r99Wired) return;
      group.dataset.r99Wired = "1";
      var tabs = Array.prototype.slice.call(
        group.querySelectorAll('[role="tab"]')
      );
      tabs.forEach(function (tab) {
        tab.addEventListener("click", function () {
          tabs.forEach(function (t) {
            var panel = document.getElementById(t.getAttribute("aria-controls"));
            var on = t === tab;
            t.setAttribute("aria-selected", String(on));
            t.tabIndex = on ? 0 : -1;
            if (panel) panel.hidden = !on;
          });
          tab.focus();
        });
        tab.addEventListener("keydown", function (e) {
          var i = tabs.indexOf(tab);
          var next = null;
          if (e.key === "ArrowRight") next = tabs[(i + 1) % tabs.length];
          if (e.key === "ArrowLeft") next = tabs[(i - 1 + tabs.length) % tabs.length];
          if (next) {
            e.preventDefault();
            next.click();
          }
        });
      });
    });
  }

  function openDialog(el) {
    if (!el) return;
    el.hidden = false;
    var scrim = document.getElementById(el.getAttribute("data-r99-scrim"));
    if (scrim) scrim.hidden = false;
    var focusable = el.querySelector(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );
    if (focusable) focusable.focus();
    el.dispatchEvent(new CustomEvent("r99:open"));
  }

  function closeDialog(el) {
    if (!el) return;
    el.hidden = true;
    var scrim = document.getElementById(el.getAttribute("data-r99-scrim"));
    if (scrim) scrim.hidden = true;
    el.dispatchEvent(new CustomEvent("r99:close"));
  }

  function wireDialogs() {
    document.querySelectorAll("[data-r99-open]").forEach(function (btn) {
      if (btn.dataset.r99Wired) return;
      btn.dataset.r99Wired = "1";
      btn.addEventListener("click", function () {
        openDialog(document.getElementById(btn.getAttribute("data-r99-open")));
      });
    });
    document.querySelectorAll("[data-r99-close]").forEach(function (btn) {
      if (btn.dataset.r99Wired) return;
      btn.dataset.r99Wired = "1";
      btn.addEventListener("click", function () {
        closeDialog(btn.closest('[role="dialog"]'));
      });
    });
    document.querySelectorAll("[data-r99-scrim]").forEach(function (el) {
      var scrim = document.getElementById(el.getAttribute("data-r99-scrim"));
      if (!scrim || scrim.dataset.r99Wired) return;
      scrim.dataset.r99Wired = "1";
      scrim.addEventListener("click", function () { closeDialog(el); });
    });
    document.addEventListener("keydown", function (e) {
      if (e.key !== "Escape") return;
      var open = document.querySelector('[role="dialog"]:not([hidden])');
      if (open) closeDialog(open);
    });
  }

  function toastHost() {
    var host = document.querySelector(".r99-toasts");
    if (!host) {
      host = document.createElement("div");
      host.className = "r99-toasts";
      document.body.appendChild(host);
    }
    return host;
  }

  function layoutToasts(host) {
    var gap = 18;
    var y = 0;
    Array.prototype.forEach.call(host.children, function (slot) {
      slot.style.transform = "translateY(" + y + "px)";
      var inner = slot.firstElementChild;
      y += (inner ? inner.offsetHeight : 0) + gap;
    });
  }

  var lastToastAt = 0;

  function toast(message) {
    var host = toastHost();
    var wait = Math.max(0, 280 - (Date.now() - lastToastAt));
    lastToastAt = Date.now() + wait;
    setTimeout(function () {
      var slot = document.createElement("div");
      slot.className = "r99-toast-slot";
      slot.style.transition = "none";
      var el = document.createElement("div");
      el.className = "r99-toast";
      el.setAttribute("role", "status");
      el.innerHTML =
        '<span class="r99-toast__icon" aria-hidden="true">!</span>' +
        '<span class="r99-toast__text"></span>';
      el.querySelector(".r99-toast__text").textContent = message;
      slot.appendChild(el);
      host.appendChild(slot);
      layoutToasts(host);
      requestAnimationFrame(function () {
        slot.style.transition = "";
      });
      while (host.children.length > 4) {
        host.removeChild(host.firstElementChild);
        layoutToasts(host);
      }
      setTimeout(function () {
        el.classList.add("r99-toast--out");
        setTimeout(function () {
          if (slot.parentNode) slot.parentNode.removeChild(slot);
          layoutToasts(host);
        }, 190);
      }, 2600);
    }, wait);
  }
  function wireReplayButtons() {
    document.querySelectorAll("[data-r99-replay]").forEach(replayStrip);
  }

  function wireToastButtons() {
    document.querySelectorAll("[data-r99-toast]").forEach(function (btn) {
      if (btn.dataset.r99Wired) return;
      btn.dataset.r99Wired = "1";
      btn.addEventListener("click", function () {
        toast(btn.getAttribute("data-r99-toast"));
      });
    });
  }

  function wireIndicators() {
    document.querySelectorAll("[data-r99-indicators]").forEach(function (list) {
      if (list.dataset.r99Wired) return;
      list.dataset.r99Wired = "1";
      var buttons = Array.prototype.slice.call(list.querySelectorAll("button"));
      buttons.forEach(function (btn) {
        btn.addEventListener("click", function () {
          buttons.forEach(function (b) {
            b.setAttribute("aria-current", String(b === btn));
          });
        });
      });
    });
  }

  function boot() {
    restoreTheme();
    wireTheme();
    wireTabs();
    wireDialogs();
    wireToastButtons();
  wireReplayButtons();
    wireIndicators();
    reveal();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }

  window.r99 = { theme: theme, toast: toast, openDialog: openDialog, closeDialog: closeDialog };
})();
