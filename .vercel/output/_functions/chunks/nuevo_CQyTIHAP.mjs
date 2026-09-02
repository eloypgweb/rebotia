import { t as __exportAll } from "./rolldown-runtime_D7D4PA-g.mjs";
import { O as renderTemplate, R as createAstro, S as renderComponent, j as addAttribute, k as maybeRenderHead } from "./sequence_Cw2Njjgx.mjs";
import { t as createComponent } from "./compiler_BEFu2b5Y.mjs";
import { t as $$Layout } from "./Layout_f2732cNd.mjs";
//#region src/pages/coach/jugadoras/nuevo.astro
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
		const equipo_id = formData.get("equipo_id")?.toString();
		const nombre = formData.get("nombre")?.toString().trim();
		const dorsalRaw = formData.get("dorsal")?.toString().trim();
		const dorsal = dorsalRaw ? Number(dorsalRaw) : null;
		const posicion = formData.get("posicion")?.toString().trim() || null;
		if (!equipo_id || !nombre) error = "El equipo y el nombre son obligatorios.";
		else {
			const { error: insertError } = await Astro.locals.supabase.from("jugadoras").insert({
				equipo_id,
				nombre,
				dorsal,
				posicion
			});
			if (insertError) error = insertError.message;
			else return Astro.redirect("/coach/jugadoras");
		}
	}
	const { data: equipos } = await Astro.locals.supabase.from("equipos").select("id, nombre").order("nombre");
	const inputClass = "rounded-lg border border-club-blue/40 px-3 py-2 text-club-navy outline-none focus:border-club-blue focus:ring-2 focus:ring-club-blue/30";
	const labelClass = "text-sm font-medium text-club-navy";
	return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "title": "Nueva jugadora — Rebotia" }, { "default": ($$result) => renderTemplate`${maybeRenderHead($$result)}<h1 class="text-2xl font-bold text-club-navy">Nueva jugadora</h1>${!equipos?.length ? renderTemplate`<p class="mt-6 rounded-xl border border-club-blue/30 bg-white p-6 text-club-navy/70 shadow-sm">Todavía no hay equipos.${" "}<a href="/coach/equipos/nuevo" class="font-medium text-club-navy hover:underline">Crea uno primero</a>.</p>` : renderTemplate`<form method="POST" class="mt-6 flex max-w-md flex-col gap-4 rounded-xl border border-club-blue/30 bg-white p-6 shadow-sm">${error && renderTemplate`<p class="text-sm text-red-600">${error}</p>`}<div class="flex flex-col gap-1"><label for="equipo_id"${addAttribute(labelClass, "class")}>Equipo</label><select id="equipo_id" name="equipo_id" required${addAttribute(inputClass, "class")}>${equipos.map((equipo) => renderTemplate`<option${addAttribute(equipo.id, "value")}>${equipo.nombre}</option>`)}</select></div><div class="flex flex-col gap-1"><label for="nombre"${addAttribute(labelClass, "class")}>Nombre</label><input id="nombre" name="nombre" type="text" required${addAttribute(inputClass, "class")}></div><div class="flex flex-col gap-1"><label for="dorsal"${addAttribute(labelClass, "class")}>Dorsal</label><input id="dorsal" name="dorsal" type="number" min="0"${addAttribute(inputClass, "class")}></div><div class="flex flex-col gap-1"><label for="posicion"${addAttribute(labelClass, "class")}>Posición</label><input id="posicion" name="posicion" type="text"${addAttribute(inputClass, "class")}></div><div class="mt-2 flex gap-4"><button type="submit" class="rounded-lg bg-club-navy px-4 py-2 font-semibold text-club-white transition-colors hover:bg-club-blue hover:text-club-navy">Crear</button><a href="/coach/jugadoras" class="rounded-lg px-4 py-2 font-semibold text-club-navy hover:underline">Cancelar</a></div></form>`}` })}`;
}, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/coach/jugadoras/nuevo.astro", void 0);
var $$file = "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/coach/jugadoras/nuevo.astro";
var $$url = "/coach/jugadoras/nuevo";
//#endregion
//#region \0virtual:astro:page:src/pages/coach/jugadoras/nuevo@_@astro
var page = () => nuevo_exports;
//#endregion
export { page };
