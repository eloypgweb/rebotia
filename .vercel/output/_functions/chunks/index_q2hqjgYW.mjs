import { t as __exportAll } from "./rolldown-runtime_D7D4PA-g.mjs";
import { O as renderTemplate, R as createAstro, S as renderComponent, k as maybeRenderHead } from "./sequence_Cw2Njjgx.mjs";
import { t as createComponent } from "./compiler_BEFu2b5Y.mjs";
import { t as $$Layout } from "./Layout_f2732cNd.mjs";
//#region src/pages/perfil/index.astro
var perfil_exports = /* @__PURE__ */ __exportAll({
	default: () => $$Index,
	file: () => $$file,
	url: () => $$url
});
createAstro("https://astro.build");
var $$Index = createComponent(($$result, $$props, $$slots) => {
	const Astro = $$result.createAstro($$props, $$slots);
	Astro.self = $$Index;
	const { user, perfil } = Astro.locals;
	const campos = [
		{
			etiqueta: "Nombre",
			valor: perfil?.nombre
		},
		{
			etiqueta: "Email",
			valor: user?.email
		},
		{
			etiqueta: "Rol",
			valor: perfil?.rol
		}
	];
	return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "title": "Mi perfil — Rebotia" }, { "default": ($$result) => renderTemplate`${maybeRenderHead($$result)}<h1 class="text-2xl font-bold text-club-navy">Mi perfil</h1><dl class="mt-6 divide-y divide-club-blue/20 rounded-xl border border-club-blue/30 bg-white shadow-sm">${campos.map((campo) => renderTemplate`<div class="flex justify-between px-6 py-4"><dt class="text-sm font-medium text-club-navy/60">${campo.etiqueta}</dt><dd class="text-sm font-medium text-club-navy">${campo.valor}</dd></div>`)}</dl>` })}`;
}, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/perfil/index.astro", void 0);
var $$file = "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/perfil/index.astro";
var $$url = "/perfil";
//#endregion
//#region \0virtual:astro:page:src/pages/perfil/index@_@astro
var page = () => perfil_exports;
//#endregion
export { page };
