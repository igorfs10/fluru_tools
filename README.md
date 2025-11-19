# FluRu Tools — Flutter/Rust (desktop + WASM)

Pequena aplicação Flutter com ferramentas simples para verificação de integridade de arquivos e de formatos de texto json,xml, yaml e csv.
Versão web: https://igorfs10.github.io/fluru_tools/

## Pré-requisitos
- Flutter

---

## Executar (Desktop)
```bash
flutter run
```

## Build (Desktop)
```bash
flutter build windows --release
```

## Executar (WebAssembly)
```bash
flutter run --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp
```

## Build (WebAssembly)
```bash
flutter build web --release --wasm --base-href /[your-base-url]/
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