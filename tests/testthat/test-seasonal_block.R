test_that("Error when block_length exceeds profile length", {
  profile <- 1:10
  expect_error(
    seasonal_block(profile, block_length = 11),
    "block_length cannot be greater than the length of the profile vector"
  )
})

test_that("Error all profile values must be >= zero", {
  profile <- -3:3
  expect_error(
    seasonal_block(profile, block_length = 2),
    "all profiles values must be >= 0"
  )
})

test_that("Error when block_length not an integer", {
  profile <- 1:10
  expect_error(
    seasonal_block(profile, block_length = 3.00001),
    "block_length must be an integer"
  )
})

test_that("Works correctly for a constant profile", {
  profile <- rep(1, 5)
  # With a constant profile, every block sums to the same value.
  result <- seasonal_block(profile, block_length = 3)
  expected_percentage <- (3 / 5) * 100
  expect_equal(result$max_percentage, expected_percentage)
  # Expect the first block (days 1-3) to be returned
  expect_equal(result$peak_season_start, 1)
  expect_equal(result$peak_season_end, 3)
})

test_that("Identifies maximum block correctly with wrap-around", {
  # Use a simple vector with a clear maximum block sum.
  # profile: [1, 2, 3, 4]; total = 10
  # Blocks of 2:
  #   Day1: 1+2 = 3  (30%)
  #   Day2: 2+3 = 5  (50%)
  #   Day3: 3+4 = 7  (70%)
  #   Day4: 4+1 = 5  (50%)  [wrap-around]
  profile <- c(1, 2, 3, 4)
  result <- seasonal_block(profile, block_length = 2)
  expected_percentage <- (7 / 10) * 100
  expect_equal(round(result$max_percentage, 5), round(expected_percentage, 5))
  expect_equal(result$peak_season_start, 3)
  # For day 3, indices = c(3,4) so season_end should be 4.
  expect_equal(result$peak_season_end, 4)
})

test_that("Edge case: block_length of 1 returns the maximum single day", {
  profile <- c(2, 4, 3, 1)
  result <- seasonal_block(profile, block_length = 1)
  expected_percentage <- (4 / sum(profile)) * 100
  expect_equal(result$max_percentage, expected_percentage)
  expect_equal(result$peak_season_start, 2)
  expect_equal(result$peak_season_end, 2)
})

test_that("Edge case: block_length equals the profile length", {
  profile <- c(1, 2, 3, 4, 5)
  result <- seasonal_block(profile, block_length = length(profile))
  # The whole year is one block so it should account for 100% of the total.
  expect_equal(result$max_percentage, 100)
  expect_equal(result$peak_season_start, 1)
  # For a full-year block starting at day 1, season_end is the last day.
  expect_equal(result$peak_season_end, length(profile))
})
