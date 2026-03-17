## 添加的插件
```
Templater
Git
Excalidraw
Mermaid
```

## Callouts功能

> [!info]
> 这里是callout模块
> 支持**markdown** 和 [[Obsidian|wikilinks]].

默认有12种风格，每一种有不同的颜色和图标。只要把上面例子里的 `INFO` 替换为下面任意一个就行。
```
note
abstract, summary, tldr
info, todo
tip, hint, important
success, check, done
question, help, faq
warning, caution, attention
failure, fail, missing
danger, error
bug
example
quote, cite
```

### 标题和内容
可以自定义标题，然后直接不要主体部分

> [!TIP] Callouts can have custom titles, which also supports **markdown**!

### 折叠
可以使用 `+` 默认展开或者 `-` 默认折叠正文部分。
> [!INFO]- Are callouts foldable?
> Yes! In a foldable callout, the contents are hidden until it is expanded.

### 自定义样式
Callouts的类 型和图标是用CSS来描述，颜色是`r, g, b` 三色组，图标有相应的 icon ID (比如`lucide-info`)。也可以自定义SVG图标。
.callout[data-callout="my-callout-type"] {
    --callout-color: 100, 100, 100;
    --callout-icon: icon-id;
    --callout-icon: '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
 <circle cx="12" cy="12" r="10"></circle>
 <line x1="12" y1="8" x2="12" y2="12"></line>
 <line x1="12" y1="16" x2="12.01" y2="16"></line>
</svg>';
}

---
## 参考链接

[Callouts - Obsidian Help](https://help.obsidian.md/callouts)