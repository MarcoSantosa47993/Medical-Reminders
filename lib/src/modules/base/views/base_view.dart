import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicins_schedules/src/modules/base/models/base_menu.dart';
import 'package:responsiveness/responsiveness.dart';

class BaseView extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const BaseView(this.navigationShell, {super.key});

  @override
  State<BaseView> createState() => BaseViewState();
}

class BaseViewState extends State<BaseView> {
  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize.of(context);

    return Scaffold(
      bottomNavigationBar:
          screenSize.minimumWidth < ScreenSize.lg.minimumWidth
              ? NavigationBar(
                selectedIndex: widget.navigationShell.currentIndex,
                onDestinationSelected: widget.navigationShell.goBranch,
                backgroundColor: Colors.white,
                destinations:
                    BaseMenu.items(context)
                        .map(
                          (menuItem) => _bottombarItem(
                            label: menuItem.label,
                            icon: menuItem.icon,
                            enabled: menuItem.enabled,
                          ),
                        )
                        .toList(),
              )
              : null,
      body: Row(
        children: [
          if (screenSize.minimumWidth >= ScreenSize.lg.minimumWidth)
            NavigationRail(
              labelType: NavigationRailLabelType.all,
              groupAlignment: 0,
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: widget.navigationShell.goBranch,
              destinations:
                  BaseMenu.items(context)
                      .map(
                        (menuItem) => _sidebarItem(
                          label: menuItem.label,
                          icon: menuItem.icon,
                          enabled: menuItem.enabled,
                        ),
                      )
                      .toList(),
            ),

          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: widget.navigationShell,
            ),
          ),
        ],
      ),
    );
  }

  NavigationDestination _bottombarItem({
    required String label,
    required IconData icon,
    required bool enabled,
  }) {
    return NavigationDestination(
      icon: Icon(icon),
      label: label,
      selectedIcon: Icon(icon),
      enabled: enabled,
    );
  }

  NavigationRailDestination _sidebarItem({
    required String label,
    required IconData icon,
    required bool enabled,
  }) {
    return NavigationRailDestination(
      icon: Icon(icon),
      selectedIcon: Icon(icon),
      label: Text(label),
      disabled: !enabled,
    );
  }
}
