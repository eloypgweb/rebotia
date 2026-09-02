import { t as __exportAll } from "./rolldown-runtime_D7D4PA-g.mjs";
import { O as renderTemplate, R as createAstro, S as renderComponent, j as addAttribute, k as maybeRenderHead } from "./sequence_Cw2Njjgx.mjs";
import { t as createComponent } from "./compiler_BEFu2b5Y.mjs";
import { t as $$Layout } from "./Layout_f2732cNd.mjs";
//#region src/pages/coach/equipos/nuevo.astro
var nuevo_exports = /* @__PURE__ */ __exportAll({
	default: () => $$Nuevo,
	file: () => $$file,
	url: () => $$url
});
createAstro("https://astro.build");
var $$Nuevo = createComponent(async ($$result, $$props, $$slots) => {
	const Astro = $$result.createAstro($$props, $$slots);
	Astro.self = $$Nuevo;
	let error = null;
	if (Astro.request.method === "POST") {
		const formData = await Astro.request.formData();
		const nombre = formData.get("nombre")?.toString().trim();
		const categoria = formData.get("categoria")?.toString().trim() || null;
		const escudo_url = formData.get("escudo_url")?.toString().trim() || null;
		const es_propio = formData.get("es_propio") === "on";
		if (!nombre) error = "El nombre es obligatorio.";
		else {
			const { error: insertError } = await Astro.locals.supabase.from("equipos").insert({
				nombre,
				categoria,
				escudo_url,
				es_propio
			});
			if (insertError) error = insertError.message;
			else return Astro.redirect("/coach/equipos");
		}
	}
	const inputClass = "rounded-lg border border-club-blue/40 px-3 py-2 text-club-navy outline-none focus:border-club-blue focus:ring-2 focus:ring-club-blue/30";
	const labelClass = "text-sm font-medium text-club-navy";
	return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "title": "Nuevo equipo — Rebotia" }, { "default": ($$result) => renderTemplate`${maybeRenderHead($$result)}<h1 class="text-2xl font-bold text-club-navy">Nuevo equipo</h1><form method="POST" class="mt-6 flex max-w-md flex-col gap-4 rounded-xl border border-club-blue/30 bg-white p-6 shadow-sm">${error && renderTemplate`<p class="text-sm text-red-600">${error}</p>`}<div class="flex flex-col gap-1"><label for="nombre"${addAttribute(labelClass, "class")}>Nombre</label><input id="nombre" name="nombre" type="text" required${addAttribute(inputClass, "class")}></div><div class="flex flex-col gap-1"><label for="categoria"${addAttribute(labelClass, "class")}>Categoría</label><input id="categoria" name="categoria" type="text"${addAttribute(inputClass, "class")}></div><div class="flex flex-col gap-1"><label for="escudo_url"${addAttribute(labelClass, "class")}>URL del escudo</label><input id="escudo_url" name="escudo_url" type="url"${addAttribute(inputClass, "class")}></div><label class="flex items-center gap-2 text-sm text-club-navy"><input type="checkbox" name="es_propio" class="h-4 w-4 rounded border-club-blue/40">Es nuestro equipo</label><div class="mt-2 flex gap-4"><button type="submit" class="rounded-lg bg-club-navy px-4 py-2 font-semibold text-club-white transition-colors hover:bg-club-blue hover:text-club-navy">Crear</button><a href="/coach/equipos" class="rounded-lg px-4 py-2 font-semibold text-club-navy hover:underline">Cancelar</a></div></form>` })}`;
}, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/coach/equipos/nuevo.astro", void 0);
var $$file = "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/coach/equipos/nuevo.astro";
var $$url = "/coach/equipos/nuevo";
//#endregion
//#region \0virtual:astro:page:src/pages/coach/equipos/nuevo@_@astro
var page = () => nuevo_exports;
//#endregion
export { page };
