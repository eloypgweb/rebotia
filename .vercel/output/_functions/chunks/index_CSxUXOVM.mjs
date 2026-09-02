import { t as __exportAll } from "./rolldown-runtime_D7D4PA-g.mjs";
import { O as renderTemplate, R as createAstro, S as renderComponent, k as maybeRenderHead } from "./sequence_Cw2Njjgx.mjs";
import { t as createComponent } from "./compiler_BEFu2b5Y.mjs";
import { t as $$Layout } from "./Layout_f2732cNd.mjs";
//#region src/pages/index.astro
var pages_exports = /* @__PURE__ */ __exportAll({
	default: () => $$Index,
	file: () => $$file,
	url: () => ""
});
createAstro("https://astro.build");
var $$Index = createComponent(($$result, $$props, $$slots) => {
	const Astro = $$result.createAstro($$props, $$slots);
	Astro.self = $$Index;
	const rol = Astro.locals.perfil?.rol;
	const puedeVerCoach = rol === "admin" || rol === "editor";
	return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "title": "Rebotia" }, { "default": ($$result) => renderTemplate`${maybeRenderHead($$result)}<div class="rounded-2xl bg-club-navy px-6 py-12 text-center text-club-white sm:px-12"><h1 class="text-3xl font-bold sm:text-4xl">Bienvenido a Rebotia</h1><p class="mt-3 text-club-white/80">Sigue los partidos y las estadísticas del equipo.</p></div><div class="mt-8 grid gap-4 sm:grid-cols-2"><a href="/partidos" class="rounded-xl border border-club-blue/30 bg-white p-6 shadow-sm transition-colors hover:border-club-blue hover:bg-club-blue/10"><h2 class="text-lg font-semibold text-club-navy">Partidos jugados</h2><p class="mt-1 text-sm text-club-navy/70">Consulta el histórico de partidos y sus estadísticas.</p></a>${puedeVerCoach && renderTemplate`<a href="/coach" class="rounded-xl border border-club-blue/30 bg-white p-6 shadow-sm transition-colors hover:border-club-blue hover:bg-club-blue/10"><h2 class="text-lg font-semibold text-club-navy">Coach</h2><p class="mt-1 text-sm text-club-navy/70">Gestiona equipos, jugadoras, partidos y estadísticas.</p></a>`}</div>` })}`;
}, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/index.astro", void 0);
var $$file = "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/index.astro";
//#endregion
//#region \0virtual:astro:page:src/pages/index@_@astro
var page = () => pages_exports;
//#endregion
export { page };
