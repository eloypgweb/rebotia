import { t as __exportAll } from "./rolldown-runtime_D7D4PA-g.mjs";
import { O as renderTemplate, R as createAstro, S as renderComponent, j as addAttribute, k as maybeRenderHead } from "./sequence_Cw2Njjgx.mjs";
import { t as createComponent } from "./compiler_BEFu2b5Y.mjs";
import { t as $$Layout } from "./Layout_f2732cNd.mjs";
//#region src/pages/coach/equipos/index.astro
var equipos_exports = /* @__PURE__ */ __exportAll({
	default: () => $$Index,
	file: () => $$file,
	url: () => $$url
});
createAstro("https://astro.build");
var $$Index = createComponent(async ($$result, $$props, $$slots) => {
	const Astro = $$result.createAstro($$props, $$slots);
	Astro.self = $$Index;
	const { data: equipos, error } = await Astro.locals.supabase.from("equipos").select("*").order("nombre");
	const errorEliminar = Astro.url.searchParams.get("error");
	return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "title": "Equipos — Rebotia" }, { "default": ($$result) => renderTemplate`${maybeRenderHead($$result)}<div class="flex items-center justify-between"><h1 class="text-2xl font-bold text-club-navy">Equipos</h1><a href="/coach/equipos/nuevo" class="rounded-lg bg-club-navy px-4 py-2 text-sm font-semibold text-club-white transition-colors hover:bg-club-blue hover:text-club-navy">+ Nuevo equipo</a></div>${error && renderTemplate`<p class="mt-4 text-sm text-red-600">Error: ${error.message}</p>`}${errorEliminar && renderTemplate`<p class="mt-4 text-sm text-red-600">No se pudo eliminar: ${errorEliminar}</p>`}<div class="mt-6 divide-y divide-club-blue/20 rounded-xl border border-club-blue/30 bg-white shadow-sm">${equipos?.length === 0 && renderTemplate`<p class="p-6 text-club-navy/60">No hay equipos todavía.</p>`}${equipos?.map((equipo) => renderTemplate`<div class="flex items-center justify-between gap-4 px-6 py-4"><div class="flex items-center gap-4">${equipo.escudo_url ? renderTemplate`<img${addAttribute(equipo.escudo_url, "src")}${addAttribute(`Escudo de ${equipo.nombre}`, "alt")} class="h-10 w-10 rounded-full object-contain">` : renderTemplate`<div class="flex h-10 w-10 items-center justify-center rounded-full bg-club-blue/10 text-xs text-club-navy/40">Sin foto</div>`}<div><p class="font-medium text-club-navy">${equipo.nombre}</p><p class="text-sm text-club-navy/60">${equipo.categoria ?? "Sin categoría"} · ${equipo.es_propio ? "Propio" : "Rival"}</p></div></div><div class="flex items-center gap-4 text-sm"><a${addAttribute(`/coach/equipos/${equipo.id}/editar`, "href")} class="font-medium text-club-navy hover:underline">Editar</a><form method="POST"${addAttribute(`/coach/equipos/${equipo.id}/eliminar`, "action")}><button type="submit" class="font-medium text-red-600 hover:underline">Eliminar</button></form></div></div>`)}</div>` })}`;
}, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/coach/equipos/index.astro", void 0);
var $$file = "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/coach/equipos/index.astro";
var $$url = "/coach/equipos";
//#endregion
//#region \0virtual:astro:page:src/pages/coach/equipos/index@_@astro
var page = () => equipos_exports;
//#endregion
export { page };
