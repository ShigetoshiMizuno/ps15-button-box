# PS-15 Button Box — リポジトリ取得スクリプト
# 使い方: PowerShell で実行 → カレントディレクトリに ps15-button-box フォルダが作られる

$repo = "https://github.com/ShigetoshiMizuno/ps15-button-box.git"
$dest = "ps15-button-box"

if (Test-Path $dest) {
    Write-Host "既存フォルダを更新します: $dest" -ForegroundColor Cyan
    Push-Location $dest
    git pull
    Pop-Location
} else {
    Write-Host "クローンします: $repo" -ForegroundColor Cyan
    git clone $repo $dest
}

Write-Host "`n完了。フォルダ: $(Resolve-Path $dest)" -ForegroundColor Green
