# Setup de Bibliotecas Wx para OpenKore

Este repositório contém os arquivos necessários para instalar manualmente as bibliotecas Perl relacionadas ao WxWidgets para uso no OpenKore.

## Requisitos

Instale os seguintes componentes **exatamente nesta ordem**:

1. **Perl (Strawberry Perl 5.32.1.1 - x86)**
   Instale via Chocolatey:

   ```bash
   choco install strawberryperl --version=5.32.1.1 --x86 --yes
   ```

2. **Python 3.13.4**
   Também via Chocolatey:

   ```bash
   choco install python --version=3.13.4 -y
   ```

3. **Alien::wxWidgets**
   Instale usando `cpan`:

   ```bash
   cpan install Alien::wxWidgets
   ```

   Ou com `cpanm`, caso já tenha `App::cpanminus` instalado:

   ```bash
   cpanm Alien::wxWidgets
   ```

4. **ExtUtils::XSpp**
   Instale usando `cpan`;
   ```bash
   cpan install ExtUtils::XSpp
   ```

> Certifique-se de executar o terminal como **administrador**, especialmente se estiver usando Chocolatey ou modificando arquivos dentro do `C:\Strawberry`.

---

## Instalação das Bibliotecas

Após instalar os requisitos acima, clone este repositório e execute o script:

```bash
setup.bat
```

Este script irá:

- Copiar as bibliotecas `Wx-0.9932-0`, `Wx-TreeListCtrl-0.13-0` e `Wx-Perl-Packager-0.27-0` para a pasta correta
- Garantir permissões adequadas
- Rodar os comandos `perl Makefile.PL` e `gmake install test` para cada uma
- Limpar os arquivos temporários

---

## Resultado

Se tudo correr bem, as bibliotecas estarão instaladas no seu ambiente Perl e prontas para uso com OpenKore.

---

## Módulos Adicionais

Após a instalação com `setup.bat`, instale os seguintes módulos Perl:

```
Wx::Demo
Wx::GLCanvas
UNIVERSAL::require
ExtUtils::XSpp
IO::Scalar
List::Util
File::Path
File::Slurp
File::chdir
Text::Balanced
Digest::MD5
OpenGL
```

Você pode instalá-los com `cpan` ou `cpanm`, conforme sua preferência.

---

## Compilando o OPK

Finalizada a instalação de todos os passos, rode o openkore com

```bash
perl openkore.pl --interface=Wx
```
