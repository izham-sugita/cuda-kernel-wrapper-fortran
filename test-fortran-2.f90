program fortest

! simple program which creates 2 vectors and adds them in a 
! cuda function

implicit none

integer*4 :: i
integer*4, parameter :: N=1024
real*4, dimension(N) :: a, b

do i=1,N
  a(i)=i*1.0
  b(i)=2.0
end do

print *, 'a = ', (a(i), i=1,10)
print *, ''

!manual
do i = 1, N
a(i) = a(i) + b(i)
end do

print*, 'CPU calculation'
print *, 'a = ', (a(i), i=1,10)
print*, ''

do i = 1, N
a(i) = i*1.0
end do

call vectoraddwrapper(a, b, N)
print*, 'GPU computation'
print *, 'a + 2 = ', (a(i), i=1,10)

end program fortest

