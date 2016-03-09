using Uno;

namespace Fuse
{

	public static class OptionalExtensions
	{
		public static Optional<T> ToOptional<T>(this T self) where T : class
		{
			return self == null 
				? Optional.None<T>()
				: Optional.Some<T>(self);
		}

		public static TResult Or<T, TResult>(this Optional<T> self, TResult fallback) //where T : TResult
		{
			return self.HasValue
				? (TResult)(object)self.Value
				: (TResult)fallback;
		}

		public static Optional<T> Or<T>(this Optional<T> self, Optional<T> fallback)
		{
			return self.HasValue
				? self
				: fallback;
		}
	}

	public class Optional
	{

		public static Optional<T> Some<T>(T value)
		{
			return new Optional<T>(true, value);
		}

		public static Optional<T> None<T>()
		{
			return new Optional<T>(false, default(T));
		}

		public static Optional None()
		{
			return new Optional();
		}

		Optional() { }
	}

	public struct Optional<T>
	{
		readonly bool _hasValue;
		T _value;

		public bool HasValue
		{
			get { return _hasValue; }
		}

		public T Value
		{
			get
			{
				if (!_hasValue) throw new InvalidOperationException();
				return _value;
			}
		}

		internal Optional(bool hasValue, T value)
		{
			_hasValue = hasValue;
			_value = value;
		}

		public static implicit operator Optional<T>(T value)
		{
			return new Optional<T>(true, value);
		}

		public static implicit operator Optional<T>(Optional value)
		{
			return new Optional<T>(false, default(T));
		}

		public override bool Equals(object obj)
		{
			if (ReferenceEquals(null, obj)) return false;
			return obj is Optional<T> && Equals((Optional<T>)obj);
		}
		
		public bool Equals(Optional<T> other)
		{
			return _hasValue.Equals(other._hasValue) && _value.Equals(other._value);
		}

		public override int GetHashCode()
		{
			//unchecked
			{
				return (_hasValue.GetHashCode() * 397) ^ _value.GetHashCode();
			}
		}

		public static bool operator ==(Optional<T> left, Optional<T> right)
		{
			return left.Equals(right);
		}

		public static bool operator !=(Optional<T> left, Optional<T> right)
		{
			return !left.Equals(right);
		}

		public override string ToString()
		{
			return HasValue 
				? "Some {" + Value + "}"
				: "None";
		}
	}

}