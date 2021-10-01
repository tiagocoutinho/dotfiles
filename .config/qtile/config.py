from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.lazy import lazy
from libqtile import layout, bar, widget

from typing import List  # noqa: F401

mod = "mod4"

keys = [
    # Switch between windows in current stack pane
    Key([mod], "k", lazy.layout.down()),
    Key([mod], "j", lazy.layout.up()),

    # Move windows up or down in current stack
    Key([mod, "control"], "k", lazy.layout.shuffle_down()),
    Key([mod, "control"], "j", lazy.layout.shuffle_up()),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next()),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
    Key([mod], "Return", lazy.spawn("alacritty")),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "w", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),
]

groups = [Group(i) for i in "asdfuiop"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen()),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    ])

layouts = [
    layout.Max(),
    layout.Stack(num_stacks=2),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Columns(),
    layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='mono',
    fontsize=16,
    padding=3,
    border_width=0,
    margin_x=0,
    margin_y=0,
    line_width=3,
)
extension_defaults = widget_defaults.copy()


class Tango(widget.base.ThreadedPollText):

    orientations = widget.base.ORIENTATION_HORIZONTAL
    defaults = [
        ("format", "{label}: {value}{unit}", "Formatting for field names."),
    ]

    def __init__(self, attr_name, **config):
        self._attr_name = attr_name
        self._attr = None
        super().__init__(**config)
        self.add_defaults(Tango.defaults)

    def poll(self):
        import tango
        if self._attr is None:
            try:
                self._attr = tango.AttributeProxy(self._attr_name)
                config = self._attr.get_config()
                self._config = dict(label=config.label, unit=config.unit)
            except tango.DevFailed as err:
                return str(err)
        try:
            value = '{:.3f}'.format(self._attr.read().value)
        except tango.DevFailed as err:
            value = '-----'
        self._config['value'] = value
        return self.format.format(**self._config)


screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(font='sans', fontsize=12, highlight_method='block'),
                widget.Prompt(),
                widget.WindowName(),
                widget.Sep(foreground='AAAAAA'),
#                Tango('controls05:10000/sys/tg_test/1/double_scalar'),
#                widget.Sep(foreground='AAAAAA'),
                widget.Net(),
                widget.NetGraph(
                    graph_color='FF2222',
                    fill_color='AA2222'
                ),
                widget.Sep(foreground='AAAAAA'),
                widget.DF(),
                widget.CPU(),
                widget.CPUGraph(
                    graph_color='22FF22',
                    fill_color='22AA22',
                ),
                widget.Sep(foreground='AAAAAA'),
                widget.Memory(format='Mem: {MemUsed}MB'),
                widget.MemoryGraph(),
                widget.Sep(foreground='AAAAAA'),
                widget.Battery(
                    full_char='\U0001F970',
                    discharge_char='\U0001F44E',
                    empty_char='\U0001F976',
                    charge_char='\U0001F44D',
                    format='\U0001F50B{char}{percent:2.0%}'
                ),
                widget.Sep(foreground='AAAAAA'),
                widget.Systray(),
                widget.Sep(foreground='AAAAAA'),
                widget.Clock(format='%Y-%m-%d %H:%M'),
                widget.QuickExit(
                    default_text='[\U0001F6AA]',
                    countdown_format='[{}s]'
                ),
            ],
            24,
            background='888888',
            opacity=1
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

