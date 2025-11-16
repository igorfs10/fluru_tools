# FluRu Tools — Flutter/Rust (desktop + WASM)

Pequena aplicação rust com interface gráfica FLutter com ferramentas simples para verificação de integridade de arquivos e de formatos de texto json,xml, yaml e csv.
Versão web: https://igorfs10.github.io/fluru_tools/

## Pré-requisitos
- Rust estável (via `rustup`)
- flutter_rust_bridge_codegen (cargo install flutter_rust_bridge_codegen)

---

## Executar (Desktop)
```bash
flutter run
```

## Executar-build (WebAssembly)
```bash
flutter_rust_bridge_codegen build-web
# ... or any other standard Flutter ways
flutter run --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp
```


## HDoc request format

```
<<METHOD
GET
METHOD
<<URL
https://igorfs10.github.io/PokemonSite/api/1/
URL
<<HEADERS
Content-Type: application/json
HEADERS
<<BODY
{
	"name": "name",
	"phone": "1234532"
}
BODY
```
> METHOD and URL are required