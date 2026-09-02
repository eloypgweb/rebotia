import { t as __exportAll } from "./rolldown-runtime_D7D4PA-g.mjs";
//#region src/pages/coach/jugadoras/[id]/eliminar.ts
var eliminar_exports = /* @__PURE__ */ __exportAll({ POST: () => POST });
var POST = async ({ params, locals, redirect }) => {
	const { error, count } = await locals.supabase.from("jugadoras").delete({ count: "exact" }).eq("id", params.id);
	if (error) return redirect(`/coach/jugadoras?error=${encodeURIComponent(error.message)}`);
	if (!count) return redirect(`/coach/jugadoras?error=${encodeURIComponent("No se ha eliminado nada (revisa los permisos).")}`);
	return redirect("/coach/jugadoras");
};
//#endregion
//#region \0virtual:astro:page:src/pages/coach/jugadoras/[id]/eliminar@_@ts
var page = () => eliminar_exports;
//#endregion
export { page };
