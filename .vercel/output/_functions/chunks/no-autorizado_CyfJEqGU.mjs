import { t as __exportAll } from "./rolldown-runtime_D7D4PA-g.mjs";
import { O as renderTemplate, S as renderComponent, k as maybeRenderHead } from "./sequence_Cw2Njjgx.mjs";
import { t as createComponent } from "./compiler_BEFu2b5Y.mjs";
import { t as $$Layout } from "./Layout_f2732cNd.mjs";
//#region src/pages/no-autorizado.astro
var no_autorizado_exports = /* @__PURE__ */ __exportAll({
	default: () => $$NoAutorizado,
	file: () => $$file,
	url: () => $$url
});
var $$NoAutorizado = createComponent(($$result, $$props, $$slots) => {
	return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "title": "Acceso no autorizado — Rebotia" }, { "default": ($$result) => renderTemplate`${maybeRenderHead($$result)}<div class="mx-auto max-w-md rounded-xl border border-club-blue/30 bg-white p-8 text-center shadow-sm"><h1 class="text-2xl font-bold text-club-navy">Acceso no autorizado</h1><p class="mt-3 text-club-navy/70">Tu cuenta no tiene permisos para entrar en la zona de gestión (Coach). Esta sección está reservada al cuerpo técnico.</p><a href="/" class="mt-6 inline-block rounded-full bg-club-navy px-5 py-2 font-semibold text-club-white transition-colors hover:bg-club-blue hover:text-club-navy">Volver al inicio</a></div>` })}`;
}, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/no-autorizado.astro", void 0);
var $$file = "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/no-autorizado.astro";
var $$url = "/no-autorizado";
//#endregion
//#region \0virtual:astro:page:src/pages/no-autorizado@_@astro
var page = () => no_autorizado_exports;
//#endregion
export { page };
