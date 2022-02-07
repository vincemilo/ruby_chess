def two_sum(nums, target)
  checked = {}

  nums.each_with_index do |val, i|
    diff = target - val
    return [checked[diff], i] if checked[diff]

    checked[val] = i
  end
end

p two_sum([2, 7, 11, 15], 9)

# Example 1:

# Input: nums = [2,7,11,15], target = 9
# Output: [0,1]
# Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].

# Example 2:

# Input: nums = [3,2,4], target = 6
# Output: [1,2]

# Example 3:

# Input: nums = [3,3], target = 6
# Output: [0,1]
