import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/tickets/cubit/ticket_cubit.dart';
import 'package:rentvyn_tenant/features/tickets/state/ticket_state.dart';

class RaiseComplaintPage extends StatefulWidget {
  const RaiseComplaintPage({super.key});

  @override
  State<RaiseComplaintPage> createState() =>
      _RaiseComplaintPageState();
}

class _RaiseComplaintPageState
    extends State<RaiseComplaintPage> {
  final TextEditingController
      descriptionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    context
        .read<TicketsCubit>()
        .loadComplaintTypes();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
        TicketsCubit,
        TicketsState>(
          
      listener: (context, state) {
          print("CREATE SUCCESS STATE => ${state.createSuccess}");
        if (state.error != null &&
            state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content:
                  Text(state.error!),
            ),
          );
        }

        if (state.createSuccess) {
           print("NAVIGATION TRIGGERED");
          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              backgroundColor:
                  Colors.green,
              content: Text(
                "Complaint Submitted Successfully",
              ),
            ),
          );

          Navigator.pop(context, true);
        }
        
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Raise Complaint",
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<
            TicketsCubit,
            TicketsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Complaint Type",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  state.complaintTypes
                          .isEmpty
                      ? const Center(
                          child:
                              CircularProgressIndicator(),
                        )
                      : DropdownButtonFormField<
                          int>(
                          value: state
                              .complaintTypeId,
                          decoration:
                              InputDecoration(
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                          ),
                          items: state
                              .complaintTypes
                              .map(
                                (
                                  type,
                                ) =>
                                    DropdownMenuItem<
                                        int>(
                                  value:
                                      type.id,
                                  child:
                                      Text(
                                    type.name,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged:
                              (value) {
                            if (value !=
                                null) {
                              context
                                  .read<
                                      TicketsCubit>()
                                  .changeComplaintType(
                                    value,
                                  );
                            }
                          },
                        ),

                  // const SizedBox(
                  //   height: 20,
                  // ),

                  // const Text(
                  //   "Priority",
                  //   style: TextStyle(
                  //     fontWeight:
                  //         FontWeight.w600,
                  //   ),
                  // ),

                  // const SizedBox(
                  //   height: 8,
                  // ),

                  // DropdownButtonFormField<
                  //     String>(
                  //   value: state.priority,
                  //   decoration:
                  //       InputDecoration(
                  //     border:
                  //         OutlineInputBorder(
                  //       borderRadius:
                  //           BorderRadius.circular(
                  //         12,
                  //       ),
                  //     ),
                  //   ),
                  //   items: const [
                  //     DropdownMenuItem(
                  //       value: "low",
                  //       child: Text(
                  //         "Low",
                  //       ),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: "normal",
                  //       child: Text(
                  //         "Normal",
                  //       ),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: "high",
                  //       child: Text(
                  //         "High",
                  //       ),
                  //     ),
                  //   ],
                  //   onChanged: (value) {
                  //     if (value != null) {
                  //       context
                  //           .read<
                  //               TicketsCubit>()
                  //           .changePriority(
                  //             value,
                  //           );
                  //     }
                  //   },
                  // ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    "Description",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  TextField(
                    controller:
                        descriptionController,
                    maxLines: 5,
                    decoration:
                        InputDecoration(
                      hintText:
                          "Describe your issue",
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 52,
                    child:
                        ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors
                                .primary,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                      onPressed:
                          state.loading
                              ? null
                              : () async {
                                  if (descriptionController
                                      .text
                                      .trim()
                                      .isEmpty) {
                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text(
                                          "Please enter description",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  await context
                                      .read<
                                          TicketsCubit>()
                                      .createComplaint(
                                        complaintTypeId:
                                            state
                                                .complaintTypeId,
                                        description:
                                            descriptionController
                                                .text
                                                .trim(),
                                        priority:
                                            state
                                                .priority,
                                      );
                                      if (context.mounted) {
  Navigator.pop(context, true);
}
                                },
                      child: state.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(
                                color: Colors
                                    .white,
                                strokeWidth:
                                    2,
                              ),
                            )
                          : const Text(
                              "Submit Complaint",
                              style:
                                  TextStyle(
                                color: Colors
                                    .white,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}