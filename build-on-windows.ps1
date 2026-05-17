# [variable]
$VERSION = "1.0.22-RELEASE"

git clone --branch $VERSION --depth 1 https://github.com/jedisct1/libsodium.git

$solution = "libsodium\builds\msvc\vs2026\libsodium.sln"

New-Item -ItemType Directory -Path "libsodium\bin" -Force | Out-Null
$log = "libsodium\bin\build.log"

Write-Host "Platform=x86"
Write-Host "Configuration=DynRelease"
& msbuild /m /v:n /p:Configuration=DynRelease /p:Platform=Win32 $solution | Tee-Object -FilePath $log -Append
if ($LASTEXITCODE -ne 0)
{
    Write-Host "*** ERROR, build terminated early, see: $log"
    Get-Content $log
    exit 1
}

Write-Host "Platform=x64"
Write-Host "Configuration=DynRelease"
& msbuild /m /v:n /p:Configuration=DynRelease /p:Platform=x64 $solution | Tee-Object -FilePath $log -Append
if ($LASTEXITCODE -ne 0)
{
    Write-Host "*** ERROR, build terminated early, see: $log"
    Get-Content $log
    exit 1
}

# ARM64

Write-Host "Complete: $solution"