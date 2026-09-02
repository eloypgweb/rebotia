import { t as __exportAll } from "./rolldown-runtime_D7D4PA-g.mjs";
import { O as renderTemplate, R as createAstro, S as renderComponent, j as addAttribute, k as maybeRenderHead } from "./sequence_Cw2Njjgx.mjs";
import { t as createComponent } from "./compiler_BEFu2b5Y.mjs";
import { t as $$Layout } from "./Layout_f2732cNd.mjs";
//#region src/pages/coach/index.astro
var coach_exports = /* @__PURE__ */ __exportAll({
	default: () => $$Index,
	file: () => $$file,
	url: () => $$url
});
createAstro("https://astro.build");
var $$Index = createComponent(($$result, $$props, $$slots) => {
	const Astro = $$result.createAstro($$props, $$slots);
	Astro.self = $$Index;
	const { user, perfil } = Astro.locals;
	const secciones = [{
		href: "/coach/equipos",
		titulo: "Equipos",
		descripcion: "Gestiona los equipos rivales y el propio."
	}, {
		href: "/coach/jugadoras",
		titulo: "Jugadoras",
		descripcion: "Gestiona la plantilla de jugadoras."
	}];
	return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "title": "Coach — Rebotia" }, { "default": ($$result) => renderTemplate`${maybeRenderHead($$result)}<h1 class="text-2xl font-bold text-club-navy">Zona Coach</h1><div class="mt-6 rounded-xl border border-club-blue/30 bg-white p-6 shadow-sm"><p class="text-club-navy/80">Sesión iniciada como <span class="font-medium text-club-navy">${user?.email}</span>(rol: <span class="font-medium text-club-navy">${perfil?.rol}</span>).</p></div><div class="mt-6 grid gap-4 sm:grid-cols-2">${secciones.map((seccion) => renderTemplate`<a${addAttribute(seccion.href, "href")} class="rounded-xl border border-club-blue/30 bg-white p-6 shadow-sm transition-colors hover:border-club-blue hover:bg-club-blue/10"><h2 class="text-lg font-semibold text-club-navy">${seccion.titulo}</h2><p class="mt-1 text-sm text-club-navy/70">${seccion.descripcion}</p></a>`)}</div>` })}`;
}, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/coach/index.astro", void 0);
var $$file = "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/coach/index.astro";
var $$url = "/coach";
//#endregion
//#region \0virtual:astro:page:src/pages/coach/index@_@astro
var page = () => coach_exports;
//#endregion
export { page };
