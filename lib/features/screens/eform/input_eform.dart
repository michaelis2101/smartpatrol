import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_patrol/features/blocs/eform/eform_bloc.dart';
import 'package:smart_patrol/features/screens/home/widget/empty_state.dart';
import 'package:smart_patrol/utils/enum.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/styles/text_styles.dart';
import 'package:smart_patrol/utils/utils.dart';

class InputEformPage extends StatefulWidget {
  final EFormBloc bloc;
  final EFormType type;

  const InputEformPage({super.key, required this.bloc, required this.type});

  @override
  State<InputEformPage> createState() => _InputEformState();
}

class _InputEformState extends State<InputEformPage> {
  late final ValueNotifier<int> stepPage;
  var totalImport = 7;

  @override
  void initState() {
    super.initState();
    stepPage = ValueNotifier(1);
    widget.bloc.add(const InitEFormEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: containerToolbarDecoration,
        ),
        title: const Text(
          'Form Input Data',
          style: kToolbarHeader,
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            widget.bloc.add(const InitEFormEvent());
            if (stepPage.value <= totalImport && stepPage.value > 1) {
              stepPage.value = stepPage.value - 1;
            } else {
              Navigator.maybePop(context);
            }
          },
        ),
      ),
      floatingActionButton: InkWell(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: kGreen, borderRadius: BorderRadius.circular(50)),
          child: const Icon(Icons.folder),
        ),
        onTap: () {
          AppUtil.showLoading();
          if (widget.type == EFormType.standard) {
            if (stepPage.value == 1) {
              widget.bloc.add(ImportFormatsEvent(
                  onSuccess: () => Navigator.of(context).pop(),
                  onFailed: (msg) {
                    Navigator.of(context).pop();
                    AppUtil.snackBar(message: msg);
                  }));
            } else if (stepPage.value == 2) {
              widget.bloc.add(ImportSectionEvent(
                  onSuccess: () => Navigator.of(context).pop(),
                  onFailed: (msg) {
                    Navigator.of(context).pop();
                    AppUtil.snackBar(message: msg);
                  }));
            } else if (stepPage.value == 3) {
              widget.bloc.add(ImportAreaEvent(
                  onSuccess: () => Navigator.of(context).pop(),
                  onFailed: (msg) {
                    Navigator.of(context).pop();
                    AppUtil.snackBar(message: msg);
                  }));
            } else if (stepPage.value == 4) {
              widget.bloc.add(ImportCplEvent(
                  onSuccess: () => Navigator.of(context).pop(),
                  onFailed: (msg) {
                    Navigator.of(context).pop();
                    AppUtil.snackBar(message: msg);
                  }));
            } else if (stepPage.value == 5) {
              widget.bloc.add(ImportEquipmentEvent(
                  onSuccess: () => Navigator.of(context).pop(),
                  onFailed: (msg) {
                    Navigator.of(context).pop();
                    AppUtil.snackBar(message: msg);
                  }));
            } else if (stepPage.value == 6) {
              widget.bloc.add(ImportServiceEvent(
                  onSuccess: () => Navigator.of(context).pop(),
                  onFailed: (msg) {
                    Navigator.of(context).pop();
                    AppUtil.snackBar(message: msg);
                  }));
            } else if (stepPage.value == 7) {
              widget.bloc.add(ImportServiceSpecialEvent(
                  onSuccess: () => {Navigator.of(context).pop()},
                  onFailed: (msg) {
                    Navigator.of(context).pop();
                    AppUtil.snackBar(message: msg);
                  }));
            }
          }
        },
      ),
      bottomNavigationBar: Container(
        height: 60,
        alignment: Alignment.centerRight,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: InkWell(
            child: ValueListenableBuilder(
              valueListenable: stepPage,
              builder: (context, value, child) => Text(
                value < totalImport ? 'Next' : 'Finish',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            onTap: () => {
              if (stepPage.value < totalImport)
                {stepPage.value = stepPage.value + 1}
              else
                {Navigator.maybePop(context)}
            },
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ValueListenableBuilder(
                valueListenable: stepPage,
                builder: (context, value, child) => LinearProgressIndicator(
                    minHeight: 10,
                    backgroundColor: kGreyLight,
                    value: value.toDouble() / totalImport,
                    color: kGreen),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ValueListenableBuilder(
              valueListenable: stepPage,
              builder: (context, value, child) {
                int step = 1;
                if (widget.type == EFormType.standard) {
                  if (value == 1) {
                    step = 1;
                  } else if (value == 2) {
                    step = 2;
                  } else if (value == 3) {
                    step = 3;
                  } else if (value == 4) {
                    step = 4;
                  } else if (value == 5) {
                    step = 5;
                  } else if (value == 6) {
                    step = 6;
                  } else {
                    step = totalImport;
                  }
                }
                return Text(
                  'Step $step of ${widget.type == EFormType.standard ? totalImport : 3}',
                  style: const TextStyle(color: kGreyLight, fontSize: 12),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: ValueListenableBuilder(
              valueListenable: stepPage,
              builder: (context, value, child) {
                String label = "";
                if (widget.type == EFormType.standard) {
                  if (value == 1) {
                    label = "Format Type";
                  } else if (value == 2) {
                    label = "Section";
                  } else if (value == 3) {
                    label = "Area";
                  } else if (value == 4) {
                    label = "Document";
                  } else if (value == 5) {
                    label = "Equipments";
                  } else if (value == 6) {
                    label = "Service";
                  } else {
                    label = "Services Special Job";
                  }
                }

                return Text(
                  '$label Form Input',
                  style: const TextStyle(color: kRichBlack, fontSize: 16),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: ValueListenableBuilder(
              valueListenable: stepPage,
              builder: (context, value, child) =>
                  BlocBuilder<EFormBloc, EFormState>(
                      bloc: widget.bloc,
                      builder: (context, state) {
                        int total = 0;
                        if (widget.type == EFormType.standard) {
                          if (value == 1) {
                            total = state.formats.length;
                          } else if (value == 2) {
                            total = state.section.length;
                          } else if (value == 3) {
                            total = state.areas.length;
                          } else if (value == 4) {
                            total = state.cpls.length;
                          } else if (value == 5) {
                            total = state.equipments.length;
                          } else if (value == 6) {
                            var tmpService = state.services
                                .where((s) => s.step.isEmpty)
                                .toList();
                            total = tmpService.length;
                          } else {
                            var tmpService = state.services
                                .where((s) => s.step.isNotEmpty)
                                .toList();
                            total = tmpService.length;
                          }
                        }

                        return Text(
                          'Total Data: $total',
                          style:
                              const TextStyle(color: kRichBlack, fontSize: 14),
                        );
                      }),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ValueListenableBuilder(
                valueListenable: stepPage,
                builder: (context, value, state) =>
                    BlocBuilder<EFormBloc, EFormState>(
                  bloc: widget.bloc,
                  builder: (context, state) {
                    int itemCount = 0;
                    if (widget.type == EFormType.standard) {
                      if (value == 1) {
                        itemCount = state.formats.length;
                        if (itemCount > 0) {
                          return listItem(
                              state: state, itemCount: itemCount, step: 1);
                        } else {
                          return EmptyStateWidget(label: 'Format');
                        }
                      } else if (value == 2) {
                        itemCount = state.section.length;
                        if (itemCount > 0) {
                          return listItem(
                              state: state, itemCount: itemCount, step: 2);
                        } else {
                          return EmptyStateWidget(label: 'Section');
                        }
                      } else if (value == 3) {
                        itemCount = state.areas.length;
                        if (itemCount > 0) {
                          return listItem(
                              state: state, itemCount: itemCount, step: 3);
                        } else {
                          return EmptyStateWidget(label: 'Area');
                        }
                      } else if (value == 4) {
                        itemCount = state.cpls.length;
                        if (itemCount > 0) {
                          return listItem(
                              state: state, itemCount: itemCount, step: 4);
                        } else {
                          return EmptyStateWidget(label: 'Document');
                        }
                      } else if (value == 5) {
                        itemCount = state.equipments.length;
                        if (itemCount > 0) {
                          return listItem(
                              state: state, itemCount: itemCount, step: 5);
                        } else {
                          return EmptyStateWidget(label: 'Equipment');
                        }
                      } else if (value == 6) {
                        var tmpService = state.services
                            .where((s) => s.step.isEmpty)
                            .toList();

                        itemCount = tmpService.length;
                        if (itemCount > 0) {
                          return listItem(
                              state: state, itemCount: itemCount, step: 6);
                        } else {
                          return EmptyStateWidget(label: 'Service');
                        }
                      } else {
                        var tmpService = state.services
                            .where((s) => s.step.isNotEmpty)
                            .toList();
                        itemCount = tmpService.length;
                        if (itemCount > 0) {
                          return listItem(
                              state: state, itemCount: itemCount, step: 7);
                        } else {
                          return EmptyStateWidget(label: 'Service Special Job');
                        }
                      }
                    } else {
                      if (value == (1 / 3)) {
                        itemCount = state.specialJobCpl.length;
                        if (itemCount > 0) {
                          return listItem(
                              state: state, itemCount: itemCount, step: 1);
                        } else {
                          return EmptyStateWidget(label: 'CPL Special Job');
                        }
                      } else if (value == (2 / 3)) {
                        itemCount = state.specialJobPosition.length;
                        if (itemCount > 0) {
                          return listItem(
                              state: state, itemCount: itemCount, step: 2);
                        } else {
                          return EmptyStateWidget(
                              label: 'Special Job Position');
                        }
                      } else {
                        itemCount = state.specialJobForm.length;
                        if (itemCount > 0) {
                          return listItem(
                              state: state, itemCount: itemCount, step: 3);
                        } else {
                          return EmptyStateWidget(label: 'Special Job Form');
                        }
                      }
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listItem(
          {required EFormState state,
          required int itemCount,
          required int step}) =>
      ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          String title = '', subtitle = '';
          if (widget.type == EFormType.standard) {
            if (step == 1) {
              title = state.formats[index].kodeFormat;
              subtitle = state.formats[index].kodeFormat;
            } else if (step == 2) {
              title = state.section[index].namaSection;
              subtitle = state.section[index].kodeSection;
            } else if (step == 3) {
              title = state.areas[index].namaArea;
              subtitle = state.areas[index].kodeArea;
            } else if (step == 4) {
              title = state.cpls[index].namaCpl;
              subtitle = state.cpls[index].kodeCpl;
            } else if (step == 5) {
              title = state.equipments[index].namaEquipment;
              subtitle = state.equipments[index].kodeEquipment;
            } else if (step == 6) {
              var tmpService =
                  state.services.where((s) => s.step.isEmpty).toList();
              title = tmpService[index].namaService;
              subtitle = tmpService[index].kodeEquipment;
            } else {
              var tmpService =
                  state.services.where((s) => s.step.isNotEmpty).toList();
              title = tmpService[index].namaService;
              subtitle = tmpService[index].kodeEquipment;
            }
          }

          return Card(
            color: Colors.white,
            child: ListTile(
              title: Text(
                title,
                style: const TextStyle(fontSize: 14, color: kRichBlack),
              ),
              subtitle: Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: kGreyLight),
              ),
            ),
          );
        },
      );
}
