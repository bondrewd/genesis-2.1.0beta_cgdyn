!--------1---------2---------3---------4---------5---------6---------7---------8
!
!> Program  kc_main
!! @brief   analysis trajectory files
!! @authors Takaharu Mori (TM)
!
!  (c) Copyright 2014 RIKEN. All rights reserved.
!
!--------1---------2---------3---------4---------5---------6---------7---------8

#ifdef HAVE_CONFIG_H
#include "../../../config.h"
#endif

program kc_main

  use kc_analyze_mod
  use kc_setup_mod
  use kc_control_mod
  use kc_option_str_mod
  use fitting_str_mod
  use trajectory_str_mod
  use input_str_mod
  use output_str_mod
  use molecules_str_mod
  use fileio_control_mod
  use string_mod
  use messages_mod
  use mpi_parallel_mod

  implicit none

  ! local variables
  character(MaxFilename) :: ctrl_filename
  type(s_ctrl_data)      :: ctrl_data
  type(s_input)          :: input
  type(s_molecule)       :: molecule
  type(s_trj_list)       :: trj_list
  type(s_trajectory)     :: trajectory
  type(s_fitting)        :: fitting
  type(s_output)         :: output
  type(s_option)         :: option


  my_city_rank = 0
  nproc_city   = 1
  main_rank    = .true.


  ! show usage
  !
  call usage(ctrl_filename)


  ! [Step1] Read control file
  !
  write(MsgOut,'(A)') '[STEP1] Read Control Parameters for Analysis'
  write(MsgOut,'(A)') ' '

  call control(ctrl_filename, ctrl_data)


  ! [Step2] Set relevant variables and structures
  !
  write(MsgOut,'(A)') '[STEP2] Set Relevant Variables and Structures'
  write(MsgOut,'(A)') ' '

  call setup(ctrl_data,  &
             input,      &
             molecule,   &
             trj_list,   &
             trajectory, &
             fitting,    &
             option,     &
             output)


  ! [Step3] Analyze trajectory
  !
  write(MsgOut,'(A)') '[STEP3] Analysis trajectory files'
  write(MsgOut,'(A)') ' '

  call analyze(molecule,   &
               input,      &
               trj_list,   &
               trajectory, &
               fitting,    &
               option,     &
               output)


  ! [Step4] Deallocate memory
  !
  write(MsgOut,'(A)') '[STEP4] Deallocate memory'
  write(MsgOut,'(A)') ' '

  call dealloc_trajectory(trajectory)
  call dealloc_trj_list(trj_list)
  call dealloc_molecules_all(molecule)
  call dealloc_option(option)

  stop

end program kc_main