import { t as __exportAll } from "./rolldown-runtime_D7D4PA-g.mjs";
import { O as renderTemplate, R as createAstro, S as renderComponent, j as addAttribute, k as maybeRenderHead } from "./sequence_Cw2Njjgx.mjs";
import { t as createComponent } from "./compiler_BEFu2b5Y.mjs";
import { t as $$Layout } from "./Layout_f2732cNd.mjs";
//#region src/pages/coach/jugadoras/index.astro
var jugadoras_exports = /* @__PURE__ */ __exportAll({
	default: () => $$Index,
	file: () => $$file,
	url: () => $$url
});
createAstro("https://astro.build");
var $$Index = createComponent(async ($$result, $$props, $$slots) => {
	const Astro = $$result.createAstro($$props, $$slots);
	Astro.self = $$Index;
	const { data: jugadoras, error } = await Astro.locals.supabase.from("jugadoras").select("*, equipos(nombre)").order("nombre");
	const errorEliminar = Astro.url.searchParams.get("error");
	return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "title": "Jugadoras — Rebotia" }, { "default": ($$result) => renderTemplate`${maybeRenderHead($$result)}<div class="flex items-center justify-between"><h1 class="text-2xl font-bold text-club-navy">Jugadoras</h1><a href="/coach/jugadoras/nuevo" class="rounded-lg bg-club-navy px-4 py-2 text-sm font-semibold text-club-white transition-colors hover:bg-club-blue hover:text-club-navy">+ Nueva jugadora</a></div>${error && renderTemplate`<p class="mt-4 text-sm text-red-600">Error: ${error.message}</p>`}${errorEliminar && renderTemplate`<p class="mt-4 text-sm text-red-600">No se pudo eliminar: ${errorEliminar}</p>`}<div class="mt-6 divide-y divide-club-blue/20 rounded-xl border border-club-blue/30 bg-white shadow-sm">${jugadoras?.length === 0 && renderTemplate`<p class="p-6 text-club-navy/60">No hay jugadoras todavía.</p>`}${jugadoras?.map((jugadora) => renderTemplate`<div class="flex items-center justify-between gap-4 px-6 py-4"><div><p class="font-medium text-club-navy">${jugadora.dorsal != null && renderTemplate`<span class="text-club-navy/50">#${jugadora.dorsal} </span>`}${jugadora.nombre}</p><p class="text-sm text-club-navy/60">${jugadora.equipos?.nombre ?? "Sin equipo"}${jugadora.posicion && ` · ${jugadora.posicion}`}</p></div><div class="flex items-center gap-4 text-sm"><a${addAttribute(`/coach/jugadoras/${jugadora.id}/editar`, "href")} class="font-medium text-club-navy hover:underline">Editar</a><form method="POST"${addAttribute(`/coach/jugadoras/${jugadora.id}/eliminar`, "action")}><button type="submit" class="font-medium text-red-600 hover:underline">Eliminar</button></form></div></div>`)}</div>` })}`;
}, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/coach/jugadoras/index.astro", void 0);
var $$file = "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/coach/jugadoras/index.astro";
var $$url = "/coach/jugadoras";
//#endregion
//#region \0virtual:astro:page:src/pages/coach/jugadoras/index@_@astro
var page = () => jugadoras_exports;
//#endregion
export { page };
