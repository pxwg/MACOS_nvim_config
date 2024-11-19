# 我的 neovim 配置

这是本人自用的 Neovim 配置，fork 自小马的 Neovim [配置](https://github.com/YinFengQi/nvim-config-based-on-lazyvim)，主要实现功能为：

* $\LaTeX$ 公式与 (一直在更新的) snippet 补全，实验报告数据处理的 python 计算快捷键集成;

* 基于 LSP [rime-ls](https://github.com/wlh320/rime-ls) 的中文输入法，自动匹配数学公式 (基于 [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)) 转换为英文输入法，集成 [copilotchat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim) 插件实现中文输入，利用 [autoformat](https://github.com/huacnlee/autocorrect) 插件实现中文标点自动格式化 (对 latex 与 markdown 开启), 利用[jieba](https://github.com/fxsjy/jieba) 实现中文分词;

* iTerm2 终端下的 pdf 终端预览，基于 [tdf](https://github.com/itsjunetime/tdf) 阅读器与 GPU 加速，利用 AppleScript 实现 (待集成双向查找，现在双向查找由[skim](https://skim-app.sourceforge.io/) 实现);

* OS X 环境下的 [inkscape](https://inkscape.org/) 集成，实现 latex 文档编辑时的图片绘制快捷键调用，利用 AppleScript 实现;

* 为了集成上述七扭八歪配置做出了一系列反人类举动，最终开机速度浮动在 120ms 左右;

* Dashboard 的 logo 是我和女朋友的互称，请忽略有意为之的拼写错误。

