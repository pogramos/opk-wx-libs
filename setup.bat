@echo off
setlocal

echo Iniciando processo de copia e extracao Wx...

:: Definir caminhos
set "SRC_DIR=%~dp0"
set "DEST_DIR=C:\Strawberry\cpan\build"

echo Verificando diretorio de destino...
if not exist "%DEST_DIR%" (
    mkdir "%DEST_DIR%"
)

echo Concedendo permissoes para o usuario atual...
for /F "tokens=2 delims=\\" %%i in ('whoami') do icacls "%DEST_DIR%" /grant "%%i:(OI)(CI)M" >nul

:: Copiar os diretórios silenciosamente
echo Copiando arquivos...
robocopy "%SRC_DIR%Wx-0.9932-0" "%DEST_DIR%\Wx-0.9932-0" /E /NFL /NDL /NJH /NJS /NC /NS >nul
robocopy "%SRC_DIR%Wx-TreeListCtrl-0.13-0" "%DEST_DIR%\Wx-TreeListCtrl-0.13-0" /E /NFL /NDL /NJH /NJS /NC /NS >nul
robocopy "%SRC_DIR%Wx-Perl-Packager-0.27-0" "%DEST_DIR%\Wx-Perl-Packager-0.27-0" /E /NFL /NDL /NJH /NJS /NC /NS >nul

:: Instalar os pacotes com Perl
echo Instalando Wx-0.9932-0...
cd /d "%DEST_DIR%\Wx-0.9932-0"
perl Makefile.PL
gmake install test

echo Instalando Wx-TreeListCtrl-0.13-0...
cd /d "%DEST_DIR%\Wx-TreeListCtrl-0.13-0"
perl Makefile.PL
gmake install test

echo Instalando Wx-Perl-Packager-0.27-0...
cd /d "%DEST_DIR%\Wx-Perl-Packager-0.27-0"
perl Makefile.PL
gmake install test

:: Voltar ao diretório anterior
cd /d "%SRC_DIR%"

:: Limpeza opcional
echo Limpando diretorios copiados...
rmdir /S /Q "%DEST_DIR%\Wx-0.9932-0"
rmdir /S /Q "%DEST_DIR%\Wx-TreeListCtrl-0.13-0"
rmdir /S /Q "%DEST_DIR%\Wx-Perl-Packager-0.27-0"

echo Concluido: Copia e instalacao dos pacotes Wx.

endlocal
