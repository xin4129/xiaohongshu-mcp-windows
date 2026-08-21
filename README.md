# 小红书 MCP（Windows 本地部署包）

这是 [`xpzouying/xiaohongshu-mcp`](https://github.com/xpzouying/xiaohongshu-mcp)
v2.5.0 的 Windows AMD64 本地启动封装，仅监听 `127.0.0.1:18060`。

> 本仓库不是小红书官方项目。使用前请阅读上游项目说明，并遵守平台规则与适用法律。

## 使用

首次登录：

```powershell
powershell -ExecutionPolicy Bypass -File .\login.ps1
```

扫码完成后关闭登录窗口，然后启动服务：

```powershell
powershell -ExecutionPolicy Bypass -File .\start.ps1
```

MCP 地址：`http://127.0.0.1:18060/mcp`

停止服务：

```powershell
powershell -ExecutionPolicy Bypass -File .\stop.ps1
```

通用 MCP 客户端配置见 `mcp-config.json`。Codex 配置片段见
`codex-config.toml.example`，可合并到用户 Codex 配置后重启/刷新客户端。

发布本地图片时建议放到 `images` 目录，并传入图片的绝对路径。

`images` 中的个人素材默认不会被 Git 跟踪。

## 数据与日志

- Cookie：`data/cookies.json`
- 标准输出：`data/xiaohongshu-mcp.stdout.log`
- 错误日志：`data/xiaohongshu-mcp.stderr.log`

`data` 已加入 `.gitignore`。Cookie 等同登录凭据，请勿分享或提交。

## 二进制来源与校验

`bin` 中的可执行文件来自上游
[`v2.5.0` Release](https://github.com/xpzouying/xiaohongshu-mcp/releases/tag/v2.5.0)：

- `xiaohongshu-mcp.exe`：`3578c9fcf3e7be0b79564aeceef8c4f38e0072d9357ca1f911ee14cd37bd454c`
- `xiaohongshu-login.exe`：`b003cb01dcc53d6ec542a131cf6d4e78d672ca2198a9232e0574bc3f3a3c9d6b`

在 PowerShell 中校验：

```powershell
Get-FileHash -Algorithm SHA256 .\bin\xiaohongshu-mcp.exe, .\bin\xiaohongshu-login.exe
```

也可与 `SHA256SUMS.txt` 对照。若校验不一致，请勿运行。

## 许可

上游软件按 Apache License 2.0 发布，版权归原作者及贡献者所有；详见
[`LICENSE`](LICENSE)。本仓库中的 PowerShell 启动封装同样按该许可证提供。
