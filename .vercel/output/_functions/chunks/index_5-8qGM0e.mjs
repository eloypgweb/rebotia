import { t as __exportAll } from "./rolldown-runtime_D7D4PA-g.mjs";
import { O as renderTemplate, S as renderComponent, k as maybeRenderHead } from "./sequence_Cw2Njjgx.mjs";
import { t as createComponent } from "./compiler_BEFu2b5Y.mjs";
import { t as $$Layout } from "./Layout_f2732cNd.mjs";
//#region src/pages/partidos/index.astro
var partidos_exports = /* @__PURE__ */ __exportAll({
	default: () => $$Index,
	file: () => $$file,
	url: () => $$url
});
var $$Index = createComponent(($$result, $$props, $$slots) => {
	return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "title": "Partidos jugados — Rebotia" }, { "default": ($$result) => renderTemplate`${maybeRenderHead($$result)}<h1 class="text-2xl font-bold text-club-navy">Partidos jugados</h1><div class="mt-6 rounded-xl border border-club-blue/30 bg-white p-6 text-club-navy/70 shadow-sm">Próximamente: listado de partidos.</div>` })}`;
}, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/partidos/index.astro", void 0);
var $$file = "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/partidos/index.astro";
var $$url = "/partidos";
//#endregion
//#region \0virtual:astro:page:src/pages/partidos/index@_@astro
var page = () => partidos_exports;
//#endregion
export { page };
