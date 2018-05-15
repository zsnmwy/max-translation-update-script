function judge {
    param(
        [string]$Name = $(throw "Parameter missing: -name Name")
    )
    if ($?) {
        Write-Output "           " "成功 $Name"
        Write-Output "              "
    }
    else {
        Write-Output "失败 $Name"
        Pause
        exit
    }
}

$wegame_path = "$pwd\OxygenNotIncluded_rail_Data\"
$steam_path = "$pwd\OxygenNotIncluded_Data\"

$ErrorActionPreference = "SilentlyContinue"
$judge_wegame_path = Test-Path "$wegame_path"
$judge_steam_path = Test-Path "$steam_path"
$judge_file_wegame = Test-Path "$wegame_path\debug_enable.txt"
$judge_file_steam = Test-Path "$steam_path\debug_enable.txt"
$ErrorActionPreference = "Continue"

Write-Output "           " "Author zsnmwy" "           "

if ("$judge_file_wegame" -eq "True") {
    Write-Output "          " "当前目录为wegame" "          " "已经存在开启debug的文件 debug_enable.txt 脚本即将退出"
    Pause
    exit
}
if ("$judge_file_steam" -eq "True") {
    Write-Output "          " "当前目录为steam" "          " "已经存在开启debug的文件 debug_enable.txt 脚本即将退出"
    Pause
    exit
}

if ( "$judge_wegame_path" -eq "True" ) {
    $now_path = $wegame_path
    Write-Output "wegame $now_path"
    Write-Output "  " "当前目录为WeGame版本的缺氧" "   " "如果识别错误，请关闭当前的脚本" "   " "按回车继续" "   "
    Pause
}
elseif ( "$judge_steam_path" -eq "True" ) {
    $now_path = $steam_path
    Write-Output "steam $now_path"
    Write-Output "  " "当前目录为Steam版本的缺氧" "   " "如果识别错误，请关闭当前的脚本" "   " "按回车继续" "   "
    Pause
}
else {
    Write-Output "    " "请把脚本放到缺氧的游戏根目录"
    Write-Output "   "  "Steam版本的  应该把脚本放在 \...\OxygenNotIncluded\"  
    Write-Output "   " "WeGame版本的  应该把脚本放在 \...\WeGame\rail_apps\缺氧(2000075)\"
    Pause
    exit
}
New-Item -Path $now_path -Name "debug_enable.txt" -ItemType "file"

Write-Output "           "

judge -Name "生成debug_enable.txt"

Write-Output "           " "进入游戏后，按Ctrl+F4开启debug" "           "

Pause