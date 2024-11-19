# 我的 neovim 配置

这是本人自用的 Neovim 配置，fork 自小马的 Neovim [配置](https://github.com/YinFengQi/nvim-config-based-on-lazyvim)。因为不满于 Neovim 原生的中文输入支持 (需要频繁切换输入法，且例如`jj` `jk` 等的字母快捷键不能在中文输入法被激活时使用)，进行了基于 [rime](https://github.com/rime) 的中文输入法集成，实现了中文数学笔记的无输入法切换输入，目前中文输入经短期测试可以流畅使用，已被用于课堂笔记 (虽然现在很多都是用英文写的了) 和实验报告 (这个必须得中文写) 的书写中。

*基本配置思路*：不出 BUG 就不动，出了 BUG 就修复，出了 BUG 修复不了就换插件 (这句话是 Copilot 写的)。*基本要求*：流畅书写第一位，能耗第二位，能不用 gui/gpu 加速就不用，尽可能保持终端的快速流畅低功耗 (这句话是我写的，目前在 M3 MacBook Pro 上可以使用约 15 小时，如果打开 gpu 加速大约可以用 6 小时)。

部分联动配置使用 apple script 实现，目前没有跨平台方案。Linux 下 inkscape 联动可以参考[castel 的绘图配置](https://github.com/gillescastel/inkscape-figures) 与 [castel 的图片管理配置](https://github.com/gillescastel/inkscape-shortcut-manager)。

## ✈️  Features

* $\LaTeX$ 公式与 (一直在更新的) snippet 补全，实验报告数据处理的 python 计算快捷键集成;

* 基于 LSP [rime-ls](https://github.com/wlh320/rime-ls) 的中文输入法，自动匹配数学公式 (基于 [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)) 转换为英文输入法，集成 [copilotchat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim) 插件实现中文输入，利用 [autoformat](https://github.com/huacnlee/autocorrect) 插件实现中文标点自动格式化 (对 latex 与 markdown 开启，在应用端修正了上游 formatter 的添加空行问题)，利用 [jieba](https://github.com/fxsjy/jieba) 实现中文分词;

![中文输入法](./readme_fig/cn_input.png)

* iTerm2 终端下的 pdf 终端预览，基于 [tdf](https://github.com/itsjunetime/tdf) 阅读器与 GPU 加速，利用 AppleScript 实现 (待集成双向查找，现在双向查找由[skim](https://skim-app.sourceforge.io/) 实现);

![tdf 下的 pdf 预览](./readme_fig/tdf.png)

* OS X 环境下的 [inkscape](https://inkscape.org/) 集成，实现 latex 文档编辑时的图片绘制快捷键调用，利用 AppleScript 实现。在存在 ipad 分屏的时候优先跳转到 ipad 分屏的 inkscape 窗口进行手绘，在不存在 ipad 分屏的时候跳转到 macos 的 inkscape 窗口进行绘图，利用 [SizeUp](https://www.irradiatedsoftware.com/sizeup/) 的 AppleScript 接口实现窗口管理;

* 为了集成上述七扭八歪配置做出了一系列反人类举动，最终开机速度浮动在 120ms 左右;

~~你说得对，但是 neovim 是一款开源 (迫真) 的开放世界 (迫真) 游戏，在这里你将扮演 root，导引 lua 之力，与一系列 readme 一行，没有 doc 的插件斗智斗勇，并在*解决插件冲突*的过程中逐渐发掘 VScode 的真相~~

* Dashboard 的 logo 是我和女朋友的互称，请忽略有意为之的拼写错误。

## 🤔 TODO

* 集成 [vimtex](https://github.com/lervag/vimtex) 与 tdf 阅读器的双向查找;

## 🤝 Thanks to

* [YinFengQi](https://github.com/YinFengQi)

