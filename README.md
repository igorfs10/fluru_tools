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
flutter run --wasm --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp
```

## Build (WebAssembly)
```bash
flutter build web --release --wasm --base-href /[your-base-url]/
```


## HDoc request format

```
<<METHOD
POST
METHOD
<<URL
https://httpbin.org/post
URL
<<HEADERS
Content-Type: application/json
X-Token: abc123
HEADERS
<<BODY
{
  "nome": "Fluru",
  "mensagem": "Olá!"
}
BODY
```
> METHOD and URL are required